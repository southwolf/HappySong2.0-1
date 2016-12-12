module Jpush
  class Payload

    def initialize(targets, message = nil)
      @push_payload = JPush::Push::PushPayload.new(
        platform: 'all',
        audience: JPush::Push::Audience.new.set_alias(targets),
        notification: build_notification(message)
      )
    end

    def pay
      return @push_payload
    end

    private

    def build_notification(message)
      notification = JPush::Push::Notification.new
      notification.set_android(
        alert: build_message(message),
        title: "欢乐诵"
      )
    end

    def build_message(message)
      message.blank? ? "你有新的消息了" : message
    end
  end
end
