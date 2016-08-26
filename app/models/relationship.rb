class Relationship < ActiveRecord::Base
  belongs_to :follower,  class_name: 'User'
  belongs_to :following, class_name: 'User'

  after_commit :push_follow_nofify, on: :create

  def push_follow_nofify
    Notification.create(
      :user_id => follower.id,
      :targetable_type => "User",
      :targetable_id   => following.id,
      :notification_type => 'follow'
    )
  end
end
