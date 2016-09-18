module Channel
  class ChannelController < Channel::ChannelAdminController
    def index
       redirect_to new_channel_session_path if current_user.nil?
       @schools = current_user.schools.page(params[:page]).per(1)
    end


  end
end
