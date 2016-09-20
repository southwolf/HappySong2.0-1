class Channel::ChannelAdminController < ActionController::Base

  def sigined_in?
    !current_user.nil?
  end
  def current_user
    @current_user ||= ChannelUser.find_by_token(cookies[:token]) if cookies[:token]
  end

  def authenticate!
    # error!({ error: "请登录!", detail: "请登录!" }, 401) unless current_admin
    redirect_to new_channel_session_path, alert: '请先登录哦' unless current_user
  end
  helper_method :current_user

end
