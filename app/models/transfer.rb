class Transfer < ActiveRecord::Base
  belongs_to :transfer_user, class_name:"ChannelUser"
  belongs_to :collector,     class_name:"ChannelUser"
end
