# 学生作业完成情况表
# ClassWork 的 after_commit 回调创建
class StudentWork < ApplicationRecord

  enum state: {
    '未完成': 0,
    '已完成': 1
  }
  # validation
  validates :student_id, uniqueness: { scope: :work_id }

  # associations
  belongs_to :student, class_name: 'Student', foreign_key: :student_id
  belongs_to :home_work, class_name: 'HomeWork', foreign_key: :work_id
  belongs_to :record_work, class_name: 'RecordWork', foreign_key: :work_id
  belongs_to :dynamic_work, class_name: 'DynamicWork', foreign_key: :work_id
end
