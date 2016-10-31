class WebPayController < ApplicationController

  def pay
    @user = User.find_by_auth_token(params[:token])
  end
  def success

  end

  def cancel

  end
end
