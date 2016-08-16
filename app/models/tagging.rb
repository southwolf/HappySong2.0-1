class Tagging < ActiveRecord::Base
  belongs_to :dynamic
  belongs_to :tag
end
