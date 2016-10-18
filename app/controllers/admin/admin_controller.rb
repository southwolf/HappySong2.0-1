module Admin
  class AdminController < ::Channel::ChannelAdminController
    before_action :isadmin?, only: [:index,:index_ajax,:delchannel]

    def index
      redirect_to new_channel_session_path if current_user.nil?
      msgbb=ChannelSchool.where(:passed => false).message.count()
      msgtx=ApplyCashBack.where(:passed => false).count()

      @msgcount=msgbb+msgtx

      @provinces = Province.all
    end

    def index_ajax
      redirect_to new_channel_session_path if current_user.nil?
      years = params[:years]
      month = params[:month]
      type = params[:type]
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
      if params[:pageIndex]
        @channel_users = @channel_users.page(params[:pageIndex]).per(10)
      else
        @channel_users = @channel_users
      end

    end

    def show
      if current_user.admin?
        @channel_user=ChannelUser.find(params[:id])
        @com=[['个人', false], ['公司', true]]
        @channel_user_id=params[:id]
      else
        @channel_user=ChannelUser.find(current_user.id)
        @com=[['个人', false], ['公司', true]]
        @channel_user_id=params[:id]
      end
    end


    def update
      channel_user=ChannelUser.find(params[:id])
      if channel_user.update(params[:channel_user].permit!)
        redirect_to :back, :notice => '更新成功'
      else
        redirect_to :back, :notice => '更新失败,请检查邮箱或手机是否占用'
      end
    end

    def changedistrict
      channel_user=ChannelUser.find(params[:channel_user_id])
      channel_user.district_id=params[:district_id]
      if channel_user.save
        render(:json => 'success', :layout => false)
      else
        render(:json => 'error', :layout => false)
      end
    end

    def changepwd

    end

    def dochangepwd
      channel_user=current_user
      current_user.password=params[:password]
      if channel_user.save
        render(:json => 'success', :layout => false)
      else
        render(:json => 'error', :layout => false)
      end
    end

    def delchannel
      channel_user=ChannelUser.find(params[:id])
      if channel_user.destroy
        render(:json => 'success', :layout => false)
      else
        render(:json => 'error', :layout => false)
      end
    end

  end
end
