class Channel::ChannelAdminController < ActionController::Base

  def current_user
    @current_user ||= User.find_by_token(cookies[:token]) if cookies[:token]
  end
  helper_method :current_user
end
