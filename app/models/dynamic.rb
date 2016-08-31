class Dynamic < ActiveRecord::Base
  belongs_to :user
  has_many   :taggings
  has_many   :tags, through: :taggings
  has_many   :attachments

  has_many   :dynamics,          foreign_key: 'original_dynamic_id'
  belongs_to :original_dynamic,  class_name:  'Dynamic'

  has_many   :ref_dynamics,      foreign_key: 'root_dynamic_id', class_name: "Dynamic"
  belongs_to :root_dynamic,      class_name: "Dynamic"

  has_many   :comments,   as: :commentable

  has_many   :likes,      as: :likeable
  has_many   :like_users, through: :likes

  has_many   :reports,    as: :reportable

  has_many   :notifications, as: :targetable

  after_commit :push_dynamic_notify, on: :create

  # 非转发的动态
  scope :not_relay, ->{ where(is_relay: false)}

  def push_dynamic_notify
    notifications.create(
      :user_id => user.id,
      :notification_type => 'dynamic'
    )
  end

  def addTag tag_name
    tag = Tag.find_by_name(tag_name)
    if tag.nil?
      tag = Tag.create(:name => tag_name)
      self.tags << tag
    else
      self.tags << tag
    end
  end
end
