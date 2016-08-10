class Record < ActiveRecord::Base
  has_many   :comments, as: :commentable
  belongs_to :article, counter_cache: true
  belongs_to :music,   counter_cache: true
  belongs_to :user
  has_many   :likes,      as: :likeable
  has_many   :like_users, through: :likes
  validates :file_url, :style, presence: true
end
