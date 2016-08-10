class Album < ActiveRecord::Base
  validates :file_url, presence: true
  belongs_to :user
end
