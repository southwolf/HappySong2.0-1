class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true, counter_cache: true
  belongs_to :user
  #回复
  has_many   :replys, class_name: "Comment", foreign_key: 'root_id'
  belongs_to :root,   class_name: "Comment"

  #定位回复
  has_many   :own_replys,    class_name: "Comment", foreign_key: 'top_comment_id'
  belongs_to :top_comment,   class_name: "Comment"

  has_many   :notifications, as: :targetable
  scope      :reply, -> { where(:is_reply => true) }

  validates :content, presence: true

  after_commit :push_comment_notify, on: :create

  def push_comment_notify
    if self.is_reply?
      comment = Comment.find(self.root.id)
      Notification.create(
        :notification_type => 'reply',
        :user_id           => self.user_id,
        :targetable        => comment
      )
    else
      Notification.create(
        :notification_type => 'comment',
        :user_id => self.user.id,
        :targetable_id => self.commentable_id,
        :targetable_type => self.commentable_type
      )
    end
  end

  def is_reply?
    is_reply == true
  end

end
