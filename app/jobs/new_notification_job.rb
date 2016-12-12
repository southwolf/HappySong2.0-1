class NewNotificationJob < ApplicationJob
  queue_as :notifications

  def perform(new_notification_id)
    
  end
end
