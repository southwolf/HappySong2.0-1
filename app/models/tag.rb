class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :dynamics, through: :taggings
end
