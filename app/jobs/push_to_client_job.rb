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
    android_badget = { badget: 1 }
    audience = JPush::Push::Audience.new
    audience.set_alias(user_ids)

    notification = JPush::Push::Notification.new
    notification.set_android(
      alert: notify,
      title: notify,
      extras: extras.merge(android_badget)
    ).set_ios(
      aletr: notify,
      badget: 1,
      extras: extras
    )
    push_payload = JPush::Push::push_payload.new(
      platform: ['android', 'ios'],
      audience: audience,
      notification: notification
    )
    pusher = jpush.pusher

    pusher.push(push_payload)
  end
end
