class Channel::ChannelAdminController < ActionController::Base

  def sigined_in?
    !current_user.nil?
  end
  def current_user
    @current_user ||= ChannelUser.find_by_token(cookies[:token]) if cookies[:token]
  end
  helper_method :current_user

end
