class Banner < ActiveRecord::Base
  validates :cover_img, :text, presence: true#code
end
