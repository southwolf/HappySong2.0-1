class NotifyRecordJob < ActiveJob::Base
  queue_as :notify_record

  def perform(id)
    Record.push_record_notify(id)
  end
end
