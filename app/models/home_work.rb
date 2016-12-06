# 作业 模型
class HomeWork < ApplicationRecord

  # associations
  belongs_to :teacher
  belongs_to :article

  has_many :class_works, foreign_key: :work_id, class_name: 'ClassWork'
  has_many :classes, through: class_works
end
