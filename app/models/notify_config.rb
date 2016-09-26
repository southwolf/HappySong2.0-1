class NotifyConfig < ActiveRecord::Base
  belongs_to :user
  belongs_to :push_action
end
