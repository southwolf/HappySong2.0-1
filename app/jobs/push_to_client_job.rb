class PushToClientJob < ActiveJob::Base
  queue_as :push_to_client

  def perform(user_id, notify)
    app_key       = 'e83807dedab1e27198297a43'
    master_secret = 'b7f3d205505764f6b6ec815b'
    jpush         = JPush::Client.new(app_key, master_secret)

    aliases = jpush.aliases

    return if aliases.show(user_id.to_s).body.first[1].blank?
    user = User.find(user_id)
    # badge = 1
    badge_follow  = Notification.unread_notify(user).where(notice_type: "follow").size
    badge_like    = Notification.unread_notify(user).where(notice_type: "like").size
    badge_comment = Notification.unread_notify(user).where(notice_type: "comment").size
    badge_work    = Notification.unread_notify(user).where(notice_type: "work").size
    extras = {
      nitification_id: notify[:notify_id],
      badge_follow: badge_follow,
      badge_like: badge_like,
      badge_comment: badge_comment,
      badge_work: badge_work
    }

    notice = notify[:notify_one]
    puts notify
    puts notify[:notify_one]
    #设置Audience
    audience = JPush::Push::Audience.new
    audience.set_alias(user_id.to_s)

    #设置Notification
    notification = JPush::Push::Notification.new
    notification.set_android(
      alert: notice,
      title: "欢乐诵",
      extras: extras
    ).set_ios(
      alert: notice,
      extras: extras
    )

    #构建PushPayload对象
    push_payload = JPush::Push::PushPayload.new(
      platform: ['android', 'ios'],
      audience: audience,
      notification: notification
    )
    pusher = jpush.pusher

    #推送消息
    pusher.push(push_payload)
  end
end
