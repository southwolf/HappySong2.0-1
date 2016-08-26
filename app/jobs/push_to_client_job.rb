class PushToClientJob < ActiveJob::Base
  queue_as :default

  def perform(user_ids, notify)
  end
end
