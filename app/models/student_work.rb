# 学生作业完成情况表
# ClassWork 的 after_commit 回调创建
class StudentWork < ApplicationRecord

  enum state: {
    '未完成': 0,
    '已完成': 1
  }

  # scope
  scope :unfinished, -> { where(state: 0) }
  scope :finished, -> { where(state: 1) }

  # validation
  validates :student_id, uniqueness: { scope: :work_id }

  # associations
  belongs_to :student, class_name: 'Student', foreign_key: :student_id
  belongs_to :home_work, -> { eager_load :teacher }, class_name: 'HomeWork', foreign_key: :work_id
  belongs_to :record_work, class_name: 'RecordWork', foreign_key: :work_id
  belongs_to :dynamic_work, class_name: 'DynamicWork', foreign_key: :work_id

  # delegate
  delegate :teacher_name, to: :home_work, allow_nil: true
  delegate :avatar, to: :home_work, allow_nil: true
  delegate :type, to: :home_work, allow_nil: true
  delegate :content, to: :home_work, allow_nil: true
  delegate :end_time, to: :home_work, allow_nil: true
  delegate :id, to: :home_work, prefix: :work, allow_nil: true
  delegate :avatar, to: :student, prefix: :user, allow_nil: true

  def title
    home_work.send(:title)
  end


end
