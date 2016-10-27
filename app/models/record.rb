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
  has_many   :banners, as: :targetable, dependent: :destroy

  validates :file_url, :style, presence: true

  has_many  :reports, as: :reportable

  #到此朗读时学生作业时
  belongs_to :work, ->(){ where(style: "record_work") }
  scope :public_records, -> { where(:is_public => true)}
  # default_scope { where(is_work: false)}
  # has_many  :notifications, as: :targetable

  after_commit :async_create_record_notify, :update_work_complete_status, on: :create
  after_destroy :delete_notification

  def delete_notification
    Notification.where(targetable: self).destroy_all
  end

  def async_create_record_notify
    NotifyRecordJob.perform_later(id)
  end

  def self.push_record_notify(id)
    record = Record.find(id)
    if record.is_work
      #完成作业推送通知到老师
      Notification.create(
        user: record.work.teacher,
        notice_type: 'work_complete',
        actor:       record.user,
        targetable: record
      )
      #推送给家长
       Notification.create(
        user:   record.user.parent,
        notice_type: 'work_complete',
        actor: record.user,
        targetable: record
      )
    else
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

  def update_work_complete_status
    if self.is_work
      work_article_size = self.work.articles.size
      complete_size = Record.where(user: self.user, work: self.work).size

      #如果完成的和布置的数目一致，将状态更新成完成状态
      if complete_size  == work_article_size
        self.work.work_to_students.find_by( work: self.work, student: self.user)
                                  .update(  complete: true)
      end
    end
  end
end
