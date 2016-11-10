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

  after_create  :async_create_record_notify
  after_update  :update_work_complete_status
  after_destroy :delete_notification, :reset_work_status_to_unread

  def delete_notification
    Notification.where(targetable: self).destroy_all
  end

  def async_create_record_notify
    NotifyRecordJob.perform_later(id)
  end

  def self.push_record_notify(id)
    record = Record.find(id)
    if record.is_work
      # 只有当朗读作业是公开的才推送通知
      return  if record.is_public == false

      #完成作业推送通知到老师
      Notification.create(
        user: record.work.user,
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
      Notification.bulk_insert(set_size: 100) do |worker|
        follower_ids.each do |follower_id|
          worker.add({
            actor_id: record.user_id,
            user_id:  follower_id,
            targetable_type: record.class,
            targetable_id: record.id,
            notice_type: "record"
            })
        end
      end
    end
  end

  def update_work_complete_status
    if self.is_work
      work_article_size = self.work.articles.size
      #只有朗读时公开的才是已完成的
      complete_size = Record.where(user: self.user, work: self.work, is_public: true).size

      #如果完成的和布置的数目一致，将状态更新成完成状态
      if complete_size  == work_article_size
        self.work.work_to_students.find_by( work_id: self.work.id, student: self.user)
                                  .update(complete: true)
      end
    end
  end

  # 删除朗读作业重置作业完成情况
  def reset_work_status_to_unread
    if self.is_work
      self.work.work_to_students.find_by(work_id: self.work.id, student: self.user)
                                .update_attribute(:complete, false)
    end
  end
end
