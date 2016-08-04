class Record < ActiveRecord::Base
  has_many   :comments, as: :commentable
  belongs_to :article, counter_cache: true
  belongs_to :music
  belongs_to :user
  validates :file_url, :style, presence: true
end
