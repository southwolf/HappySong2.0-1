module Channel
  class TransfersController < ChannelAdminController
    before_action :authenticate!
    def index
      channel_user = ChannelUser.find(params[:channel_user_id])
      @transfers = Transfer.page(params[:page]).per(10)
    end
  end
end
