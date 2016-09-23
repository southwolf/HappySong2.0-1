class Like < ActiveRecord::Base
  belongs_to :likeable,  polymorphic: true, counter_cache: true
  belongs_to :like_user, class_name: 'User'

  after_commit :async_create_like_notify, on: :create

  def async_create_like_notify
    NotifyLikeJob.perform_later(id)
  end
  def self.push_like_notify(id)
    like = Like.find(id)
    like_user = like.like_user
    # follower_ids = like_user.follower_ids
    return if like_user.nil?
    Notification.create(
      :actor_id => like.like_user_id,
      :user_id  => like.likeable.user.id,
      :notice_type => "like",
      :targetable  => like.likeable
    )
    # return if follower_ids.empty?
    # follower_ids.each do |follower_id|
    #   Notification.create(
    #   :actor_id    => like.like_user_id,
    #   :user_id     => follower_id,
    #   :notice_type => "like",
    #   :targetable  => like.likeable
    #   )
    # end
  end
end
