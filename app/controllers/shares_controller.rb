class SharesController < ApplicationController
  
  def share_article
    @article=Article.find(params[:id])
    render :layout => false
  end

  def share_record
    @record=Record.find(params[:id])
    render :layout => false
  end

  def share_dynamic
    @dynamic=Dynamic.find(params[:id])
    render :layout => false
  end

  def share_profile
    @user=User.find(params[:id])
    render :layout => false
  end
end
