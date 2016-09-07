class NotifyLikeJob < ActiveJob::Base
  queue_as :notify_like

  def perform(id)
    # Do something later
    Like.push_like_notify(id)
  end
end
