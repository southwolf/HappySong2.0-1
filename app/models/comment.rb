class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true, counter_cache: true
  belongs_to :user
  #回复
  has_many   :replys, class_name: "Comment", foreign_key: 'root_id'
  belongs_to :root,   class_name: "Comment"

  validates :content, presence: true
end
