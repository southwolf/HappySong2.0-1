module Channel
  class TransfersController < ChannelAdminController
    def index
      channel_user = ChannelUser.find(params[:channel_user_id])
      @transfers = channel_user.transfers
    end
  end
end
