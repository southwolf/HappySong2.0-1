class Nation < ApplicationRecord

  enum tags: { province: 1, city: 2, country: 3 }

  # scopes
  scope :cities, -> { where(tag: tags[:city]) }
  scope :counties, -> { where(tag: tags[:country]) }

  # associations
  belongs_to :parent, class_name: 'Nation', foreign_key: :parent_id
  has_many :children, class_name: 'Nation', foreign_key: :parent_id

  # instance methods
  def is_city?
    self.tag == Nation.tags[:city]
  end
end
