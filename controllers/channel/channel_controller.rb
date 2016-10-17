module Channel
  class ChannelController < Channel::ChannelAdminController
    before_action :authenticate!
    before_action :ischannel?

    #渠道登陆欢迎界面
    def index
       redirect_to new_channel_session_path if current_user.nil?
       @schoolsCount = current_user.channel_schools.where(passed: true).count
       @schools = current_user.channel_schools.where(passed: true).page(params[:page]).per(6)
       unless current_user.try(:channel_user_cash_back).nil?
         @totalAmount = current_user.try(:channel_user_cash_back).try(:amount) + current_user.try(:channel_user_cash_back).try(:used)
         @canApply = current_user.channel_user_cash_back.amount
       else
         @totalAmount = 0
          @canApply = 0
       end

    end


  end
end
