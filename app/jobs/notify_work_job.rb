class NotifyWorkJob < ActiveJob::Base
  queue_as :default

  def perform(id)
    Work.push_work_notify(id)
  end
end
