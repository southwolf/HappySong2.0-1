class Record < ActiveRecord::Base
  has_many   :comments, as: :commentable
  belongs_to :article, counter_cache: true
  belongs_to :music,   counter_cache: true
  belongs_to :user
  has_many   :likes,      as: :likeable
  has_many   :like_users, through: :likes

  has_many   :views,   foreign_key: 'view_record_id'
  has_many   :viewers, through: :views

  #banner
  has_many   :banners, as: :targetable

  validates :file_url, :style, presence: true

  has_many  :reports, as: :reportable
  # has_many  :notifications, as: :targetable

  after_commit :async_create_record_notify, on: :create

  def async_create_record_notify
    NotifyRecordJob.perform_later(id)
  end

  def self.push_record_notify(id)
    record = Record.find(id)
    user = record.user
    follower_ids = user.follower_ids
    puts record
    puts follower_ids.to_s
    return if record.nil?
    return if follower_ids.empty?
    return if record.is_public == false
    follower_ids.each do |follower_id|
      puts "join"
      Notification.create(
        actor_id: record.user_id,
        user_id:  follower_id,
        targetable: record,
        notice_type: "record"
      )
    end
  end
end
