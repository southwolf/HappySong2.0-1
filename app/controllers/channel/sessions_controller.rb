class Channel::SessionsController < Channel::ChannelAdminController

  def new
    render layout: false
  end

  def create
    user = ChannelUser.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      cookies.permanent[:token] = user.token
      redirect_to channel_root_url
    else
      redirect_to :new
    end
  end

  def destroy
    cookies.delete(:token)
    redirect_to :new
  end
end
