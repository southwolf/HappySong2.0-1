class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :dynamics, through: :taggings
  
  scope :recommend, ->{ where(:recommend => true) }
end
