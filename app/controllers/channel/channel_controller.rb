module Channel
  class ChannelController < Channel::ChannelAdminController
    def index
       redirect_to new_channel_session_path if current_user.nil?
       @channel_users = ChannelUser.channels
    end
  end
end
