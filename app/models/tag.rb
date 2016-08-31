class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :dynamics, through: :taggings
  
  # 推荐的标签
  scope :recommend, ->{ where(:recommend => true) }
end
