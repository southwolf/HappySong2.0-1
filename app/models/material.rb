# 素材 布置作业的素材 发布少年说的素材
class Material < ApplicationRecord

  # validation
  validates :url, presence: true
  
  # associations
  belongs_to :materialable, polymorphic: true
end
