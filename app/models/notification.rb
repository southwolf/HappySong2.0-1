class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :targetable, polymorphic: true

  scope :unread, -> { where(unread: true) }
end
