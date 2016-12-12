class NotifyWorkJob < ActiveJob::Base
  queue_as :notifications

  def perform(id)
    Work.push_work_notify(id)
  end
end
