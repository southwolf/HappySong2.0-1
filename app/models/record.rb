class Record < ActiveRecord::Base
  has_many   :comments, as: :commentable
  belongs_to :article, counter_cache: true
  belongs_to :music,   counter_cache: true
  belongs_to :user

  has_many   :likes,      as: :likeable
  has_many   :like_users, through: :likes

  has_many   :views,   foreign_key: 'view_record_id'
  has_many   :viewers, through: :views

  validates :file_url, :style, presence: true

  has_many  :reports, as: :reportable
  has_many  :notifications, as: :targetable

  after_commit :push_record_notify, on: :create

  def push_record_notify
    notifications.create( :user_id => self.user.id,
                          :notification_type => 'record')
  end
end
