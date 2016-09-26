class PushAction < ActiveRecord::Base
  has_many :notify_configs
  has_many :users, through: :notify_configs
end
