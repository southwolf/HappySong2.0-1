class Channel::SessionsController < Channel::ChannelAdminController
  def new
    render layout: false
  end

  def create
    user = ChannelUser.find_by_email(params[:email])
    puts user
    if user && user.authenticate(params[:password]) && YunPian.verify(user.phone, params[:code])
      cookies.permanent[:token] = user.token
      if user.admin?
        redirect_to admin_root_url
      else
        redirect_to channel_root_url
      end
    else
      puts 'error'
      render :new, layout: false
    end
  end

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
