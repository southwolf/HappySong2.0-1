class Nation < ApplicationRecord

  enum tags: { province: 1, city: 2, country: 3 }

  # scopes
  # TODO scope params
  scope :cities, -> { where(tag: 2) }
  # scope :counties, ->(city) {}

  # associations
  belongs_to :parent, class_name: 'Nation', foreign_key: :parent_id
  has_many :children, class_name: 'Nation', foreign_key: :parent_id
end
