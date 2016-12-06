# 班级学生中间表 -> 一个学生可以加入多个班级
class ClassStudent < ApplicationRecord

  # associations
  belongs_to :org_class, foreign_key: :class_id, class_name: 'Org::Class'
  belongs_to :student, foreign_key: :student_id, class_name: 'Student'
end
