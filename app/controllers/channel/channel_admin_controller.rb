class Channel::ChannelAdminController < ActionController::Base

  def sigined_in?
    !current_user.nil?
  end
  def current_user
    @current_user ||= ChannelUser.find_by_token(cookies[:token]) if cookies[:token]
  end

  def authenticate!
    redirect_to new_channel_session_path, alert: '请先登录哦' unless current_user
  end

  #是否是渠道商
  def ischannel?
    if current_user.admin?
      redirect_to new_channel_session_path
    end
  end

  #是否是管理员
  def isadmin?
      redirect_to new_channel_session_path unless current_user.nil? || current_user.admin?
  end
  helper_method :current_user

end
