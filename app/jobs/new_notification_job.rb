class NewNotificationJob < ApplicationJob
  queue_as :notifications
  def perform(actor_id, index, targetable_id, targetable_type)
    NewNotification.create(actor_id: actor_id, index: index, targetable_id: targetable_id, targetable_type: targetable_type)
  end
end
