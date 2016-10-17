module Channel
  class MessageController < ChannelAdminController
    before_action :authenticate! 
    before_action :isadmin?, only: [:admin_index, :pass_school, :nopass_school, :pass_tx]

    def admin_index
      @apply_cash_backs = ApplyCashBack.order('id desc').page(params[:page]).per(10)
      @channel_schools=ChannelSchool.order('id desc').page(params[:page]).per(10)
    end


    #报备通过
    def pass_school
      school_id=params[:id]
      channel_school=ChannelSchool.find(school_id)
      channel_school.passed=true
      if channel_school.save
        render(:json => 'success', :layout => false)
      else
        render(:json => 'fail', :layout => false)
      end
    end

    #报备不通过
    def nopass_school
      school_id=params[:id]
      channel_school=ChannelSchool.find(school_id)
      channel_school.passed=2
      channel_school.reason=params[:reason]
      if channel_school.save
        render(:json => 'success', :layout => false)
      else
        render(:json => 'fail', :layout => false)
      end
    end

    #转账
    def pass_tx
      apply = ApplyCashBack.find(params[:id])
      apply.passed=true

      #添加到转账记录表
      transfer = current_user.transfers.build(collector_id:  apply.channel_user.id, amount: apply.amount)

      if apply.save && transfer.save
        render(:json => 'success', :layout => false)
      else
        render(:json => 'fail', :layout => false)
      end
    end

    #渠道商报备记录

    def channel_baobei
      @schools=@current_user.channel_schools.page(params[:page]).per(10)
    end

    def xieyi
      render layout: false
    end
  end
end
