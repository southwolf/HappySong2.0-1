class Banner < ActiveRecord::Base
  validates :cover_img, :text, presence: true#code
  belongs_to :targetable, polymorphic: true
end
