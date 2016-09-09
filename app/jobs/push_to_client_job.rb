class PushToClientJob < ActiveJob::Base
  queue_as :push_to_client

  def perform(user_id, notify)
    app_key       = 'e83807dedab1e27198297a43'
    master_secret = 'b7f3d205505764f6b6ec815b'
    jpush         = JPush::Client.new(app_key, master_secret)
    user = User.find(user_id)
    # badge = 1
    badge = Notification.unread_notify(user).size
    extras = {
      nitification_id: notify[:notify_id]
    }
    android_badge = { badge: badge }
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
      title: notice,
      extras: extras.merge(android_badge)
    ).set_ios(
      alert: notice,
      badge: badge,
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
