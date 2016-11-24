class Org::School < ApplicationRecord
  has_many :grades
  has_many :classes, through: grades
end