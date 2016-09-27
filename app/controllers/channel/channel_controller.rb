module Channel
  class ChannelController < Channel::ChannelAdminController
    before_action :authenticate!
    def index
       redirect_to new_channel_session_path if current_user.nil?
       @schoolsCount = current_user.schools.count
       @schools = current_user.schools.page(params[:page]).per(6)
    end


  end
end
