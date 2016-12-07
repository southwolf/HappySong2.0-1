# 作业 模型
# 作业 属于 老师 （某个具体的作业由老师布置）
# 作业
class HomeWork < ApplicationRecord

  # associations
  belongs_to :teacher

  has_many :class_works, foreign_key: :work_id, class_name: 'ClassWork'
  has_many :classes, through: class_works
end
