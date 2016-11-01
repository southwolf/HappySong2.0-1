class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true, counter_cache: true
  belongs_to :user
  #回复
  has_many   :replys, class_name: "Comment", foreign_key: 'root_id'
  belongs_to :root,   class_name: "Comment"

  #定位回复
  has_many   :own_replys,    class_name: "Comment", foreign_key: 'top_comment_id'
  belongs_to :top_comment,   class_name: "Comment"

  # has_many   :notifications, as: :targetable
  scope      :reply, -> { where(:is_reply => true) }

  validates :content, presence: true

  after_commit :async_create_comment_notify, on: :create

  def async_create_comment_notify
    NotifyCommentJob.perform_later(id)
  end

  def self.push_comment_notify(id)
    comment = Comment.find(id)
    comment_user = comment.user
    return  if comment.nil?

    follower_ids = comment_user.follower_ids

    if comment.is_reply?

      c       = comment.top_comment
      user    = comment.root.user
      unless comment.user == user
        Notification.create(
          :notice_type       => 'reply',
          :actor_id          => comment.user.id,
          :user              => user,
          :targetable        => c,
          :second_targetable => comment
        )
      end
      return  if follower_ids.empty?
      follower_ids.reject! {|follower_id| follower_id == user.id}
      Notification.bulk_insert(set_size: 100) do |worker|
        follower_ids.each do |follower_id|
          worker.add({
            actor_id: comment.user.id,
            user_id: follower_id,
            targetable_type: c.class,
            targetable_id: c.id,
            second_targetable_type: comment.class,
            second_targetable_id: comment.id,
            notice_type: 'reply'
            })
        end
      end
    else
      if comment.commentable.user.id != comment.user.id
        Notification.create(
          :notice_type => 'comment',
          :user_id =>     comment.commentable.user.id,
          :actor_id =>    comment.user.id,
          :targetable =>  comment.commentable,
          :second_targetable => comment
        )
      end
      return if follower_ids.empty?
      follower_ids.reject! { |follower_id| follower_id == comment.commentable.user.id }
      Notification.bulk_insert(set_size: 100 ) do |worker|
        follower_ids.each do |follower_id|
          worker.add({
            user_id: follower_id,
            actor_id: comment.user.id,
            targetable_type: comment.commentable.class,
            targetable_id: comment.commentable.id,
            second_targetable_type: comment.class,
            second_targetable_id: comment.id,
            notice_type: 'comment'
            })
        end
      end
    end
  end

  def is_reply?
    is_reply == true
  end

end
