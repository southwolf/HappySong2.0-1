module Admin
  class Admin < Channel::ChannelAdminController
    def index
      redirect_to new_channel_session_path if current_user.nil?
      @channel_users = ChannelUser.channels.page(params[:page]).per(1)
      @provinces = Province.all
    end
  end
end
