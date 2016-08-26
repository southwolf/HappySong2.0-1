class Like < ActiveRecord::Base
  belongs_to :likeable,  polymorphic: true, counter_cache: true
  belongs_to :like_user, class_name: 'User'

  after_commit :push_like_notify, on: :create

  def push_like_notify
    Notification.create(
      :user_id => like_user.id,
      :targetable_type => likeable_type,
      :targetable_id   => likeable_id,
      :notification_type => 'like'
    )
  end
end
