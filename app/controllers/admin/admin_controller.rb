module Admin
  class AdminController < ::Channel::ChannelAdminController
    def index
      redirect_to new_channel_session_path if current_user.nil?
      years = params[:years]
      month = params[:month]
      type  = params[:type]
      district = params[:district]

      hash = {}
      if type.present?
        hash = hash.merge({:company => type})
        if district.present?
          hash = hash.merge({:district_id => district})
        end
      elsif district.present?
        hash = hash.merge ({:district_id => district})
      end
      @channel_users = ChannelUser.channels.where(hash)

      if years.present?
        @channel_users = @channel_users.where("year(created_at) = ?", years)
        if month.present?
          @channel_users = @channel_users.where("month(created_at)=?", month)
        end
      elsif month.present?
        @channel_users = @channel_users.where("month(created_at)=?", month)
      end
      @channel_users = @channel_users.page(params[:page]).per(1)
      @provinces = Province.all
    end
  end
end
