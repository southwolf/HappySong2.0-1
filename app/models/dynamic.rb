class Dynamic < ActiveRecord::Base
  belongs_to :user
  has_many   :taggings
  has_many   :tags, through: :taggings
  has_many   :attachments,       dependent: :destroy

  has_many   :dynamics,          foreign_key: 'original_dynamic_id'
  belongs_to :original_dynamic,  class_name:  'Dynamic'

  has_many   :ref_dynamics,      foreign_key: 'root_dynamic_id', class_name: "Dynamic"
  belongs_to :root_dynamic,      class_name: "Dynamic"

  has_many   :comments,   as: :commentable, dependent: :destroy

  has_many   :likes,      as: :likeable,    dependent: :destroy
  has_many   :like_users, through: :likes

  has_many   :reports,    as: :reportable,  dependent: :destroy

  belongs_to :work, ->(){ where(style: "creative_work")}
  # has_many   :notifications, as: :targetable

  after_commit :async_create_dynamic_notify, :update_work_status, on: :create
  after_destroy :delete_notification

  default_scope { where(is_work: false)}
  def delete_notification
    Notification.where(targetable: self).destroy_all
  end
  # 非转发的动态
  scope :not_relay, ->{ where(is_relay: false)}

  def async_create_dynamic_notify
    NotifyDynamicJob.perform_later(id)
  end
  def self.push_dynamic_notify(id)
    dynamic = Dynamic.find(id)
    if dynamic.is_work
      #完成作业推送通知到老师
      Notification.create(
        user:  dynamic.work.user,
        notice_type: 'work_complete',
        actor:    dynamic.user,
        targetable: dynamic
      )
      #推送给家长
      Notification.create(
        user:  dynamic.user.parent,
        notice_type: 'work_complete',
        actor: dynamic.user,
        targetable: dynamic
      )
    else
      follower_ids = dynamic.user.follower_ids

      return if dynamic.nil?
      return if follower_ids.empty?
      follower_ids.each do |follower_id|
        Notification.create(
          user_id: follower_id,
          actor_id: dynamic.user_id,
          targetable: dynamic,
          notice_type: 'dynamic'
        )
      end
    end
  end

  #更新作业完成状态
  def update_work_status
    if self.is_work
      WorkToStudent.transaction do
        work= WorkToStudent.find_by(work_id: self.work_id, student: self.user)
        work.complete = true
        work.save
      end
    end
  end


  def addTag tag_name
    tag = Tag.find_by_name(tag_name)
    if self.is_relay
      cover_img = self.user.avatar
      if tag.nil?
        tag = Tag.create(:name => tag_name, :cover_img => cover_img)
        self.tags << tag
      else
        self.tags << tag
      end
    else
      if self.attachments.first.is_video
        cover_img = self.attachments.first.file_url+"?vframe/png/offset/1/w/1280/h/720/rotate/auto"
      else
        cover_img = self.attachments.first.file_url
      end
      if tag.nil?
        tag = Tag.create(:name => tag_name, :cover_img => cover_img)
        self.tags << tag
      else
        self.tags << tag
      end
    end
  end
end
