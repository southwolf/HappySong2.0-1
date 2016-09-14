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
        redirect_to channel_root_url
      else
        redirect_to channel_root_url
      end
    else
      render :new, layout: false
    end
  end

  def destroy
    cookies.delete(:token)
    redirect_to new_channel_session_path
  end
end
