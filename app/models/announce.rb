class Announce < ActiveRecord::Base
  # has_many  :notifications, as: :targetable
  validates :content, presence: true

  after_commit :async_create_announce_notify, on: :create
  def async_create_announce_notify
    NotifyAnnounceJob.perform_later(id)
  end
  def push_announce_notify
    User.ids.each do |id|
      Notification.create(
        user_id: id,
        targetable: self,
        notice_type: "announce"
      )
    end
  end
end
