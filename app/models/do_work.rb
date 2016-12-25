# 学生写作业
class DoWork < ApplicationRecord

  # validation
  validates :user_id, presence: true

  # associatons
  belongs_to :student_work
  belongs_to :student, foreign_key: 'user_id', class_name: 'User'
  has_many :materials, as: :materialable, class_name: 'Material' # 1 或者 n 个素材

  accepts_nested_attributes_for :materials
end
