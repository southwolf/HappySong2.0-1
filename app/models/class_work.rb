# 老师 发布作业的时候会创建这个对象
# 班级作业表 一个作业可以布置给多个班级
class ClassWork < ApplicationRecord

  # associations
  belongs_to :home_work, foreign_key: :work_id, class_name: 'HomeWork'
  belongs_to :org_class, foreign_key: :class_id, class_name: 'Org::Class'
  belongs_to :record_work, foreign_key: :work_id, class_name: 'RecordWork'
  belongs_to :dynamic_work, foreign_key: :work_id, class_name: 'DynamicWork'

  # callbacks
  after_commit :build_student_works, on: :create
  def build_student_works # ActiveJob 去创建学生完成作业情况表
    CreateStudentWorkJob.perform_later(self.id)
  end

  private

end
