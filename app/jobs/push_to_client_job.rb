class PushToClientJob < ActiveJob::Base
  queue_as :push_to_client

  def perform(user_ids, notify)
    app_key       = 'e83807dedab1e27198297a43'
    master_secret = 'b7f3d205505764f6b6ec815b'
    jpush         = JPush::Cilent.new(app_key, master_secret)
    extras = {
      user_id: notification.user_id,
      type: notification.type,
      target_type: notification.targetable_type,
      target_id: notification.targetable_id

    }
    audience = JPush::Push::Audience.new
    audience.set_alias(user_ids)

    notification = JPush::Push::Notification.new
    notification.set_android(
      title: notify,
      extras: extras
    ).set_ios(
      aletr: notify,
      badget: Notification.unread.size
    )

    push_payload = JPush::Push::push_payload.new(
      platform: ['android', 'ios'],
      audience: audience,
      notification: notification
    ).set_message(
      notify,
      extras: extras
    )
    pusher = jpush.pusher

    pusher.push(push_payload)
  end
end
