class InvitesController < ApplicationController

  def show
    invite_id  = params[:code]
    @user_id = User.find_by(code: invite_id).id
  end

  def create
    user = User.new(params.permit(:phone))
    if user.save
      invite_user = User.find(params[:user_id])
      invite = invite_user.invites.new(target_user: user)
      respond_to do |format|
        if invite.save
          format.json { render :json => { code: 1, :message =>"success"}}
        else
          format.json { render :json => {code: 0, :error => "错误"} }
        end
      end
    else
      respond_to do |format|
        format.json { render json: {code: 1, error: "错误"} }
      end
    end
  end
  
end
