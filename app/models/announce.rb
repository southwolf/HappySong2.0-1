class Announce < ActiveRecord::Base
  has_many  :notifications, as: :targetable
  validates :content, presence: true

  after_commit :push_announce_notify, on: :create
  def push_announce_notify
    notifications.create(
      :notification_type => 'announce'
    )
  end
end
