# 学生写作业
# 自由朗读的话需要有 Article 的 ID
class DoWork < ApplicationRecord

  # validation
  validates :user_id, presence: true

  # associatons
  belongs_to :student_work
  belongs_to :student, foreign_key: 'user_id', class_name: 'User'
  has_many :materials, as: :materialable, class_name: 'Material' # 1 或者 n 个素材
  has_many :articles, through: :student_work

  accepts_nested_attributes_for :materials
end
