class NotifyCommentJob < ActiveJob::Base
  queue_as :notify_comment

  def perform(id)
    Comment.push_comment_notify(id)
  end
end
