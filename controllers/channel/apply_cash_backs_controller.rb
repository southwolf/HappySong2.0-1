module Channel
  class ApplyCashBacksController < ChannelAdminController
    before_action :authenticate!
    before_action :ischannel?

    def index
      channel_user = ChannelUser.find(params[:channel_user_id])
      @apply_cash_backs = channel_user.apply_cash_backs.order('id desc').page(params[:page]).per(10)
    end

  end
end
