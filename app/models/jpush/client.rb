module Jpush
  class Client
    class << self
      def hs_jpush
        @jpush ||= JPush::Client.new(APP_KEY, MASTER_SECRET)
      end

      def notify(payload)
        pusher = hs_jpush.pusher
        pusher.push(payload)
      end
    end
  end
end
