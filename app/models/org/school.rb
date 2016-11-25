class Org::School < ApplicationRecord

  # associations
  belongs_to :nation
  has_many :classes

  # delegate
  delegate :name, :fullname, to: :nation, prefix: :nation, allow_nil: true
end
