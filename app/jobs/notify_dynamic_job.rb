class NotifyDynamicJob < ActiveJob::Base
  queue_as :notify_dynamic

  def perform(id)
    # Do something later
    Dynamic.push_dynamic_notify(id)
  end
end
