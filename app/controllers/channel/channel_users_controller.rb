module Channel
  class ChannelUsersController < ChannelAdminController
    def show
      @channel_user = ChannelUser.find(params[:id])
      @schools = @channel_user.schools
    end
  end
end
