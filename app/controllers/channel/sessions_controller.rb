class Channel::SessionsController < Channel::ChannelAdminController
  def new
    render layout: false
  end

  def create
    user = ChannelUser.find_by_email(params[:email])

    cookies.permanent[:token] = user.token
    if user.admin?
      redirect_to admin_admin_index_url
    else
      redirect_to channel_channel_index_url
    end

  end

  #登录check
  def checklogin
    user = ChannelUser.find_by_email(params[:email])

    if user.nil? || !user.authenticate(params[:password])
      render(:text => '账号或密码错误', :layout => false)
      return false;
    end

    if user.phone != params[:phone]
      render(:text => '手机号不存在', :layout => false)
      return false
    end

    # if user.status == 'no'
    #   render(:text => '您的账号存在异常,请联系渠道管理员呀 021-61521541', :layout => false)
    #   return false
    # end

    # if !YunPian.verify(user.phone, params[:code])
    #   render(:text => '验证码错误', :layout => false)
    #   return false
    # end

    render(:text => 'success', :layout => false)

  end

  #注册
  def register

  end

  #处理添加渠道商
  def doreg
      @channel_user = ChannelUser.new()
      @channel_user.name=params[:name]
      @channel_user.email=params[:email]
      @channel_user.phone=params[:phone]
      @channel_user.password=params[:password]
      @channel_user.district_id=params[:district]
      @channel_user.company=params[:type]

      if ChannelUser.find_by(phone: params[:phone]) || ChannelUser.find_by(email: params[:email])
        redirect_to :back, :notice => "邮箱或手机号已存在!"
        return false;
      end

      if @channel_user.save
        redirect_to :back, :notice => 'success'
      else
        redirect_to :back, :notice => '注册失败,请重新注册'
      end
    end

  def destroy
    cookies.delete(:token)
    redirect_to new_channel_session_path
  end
end
