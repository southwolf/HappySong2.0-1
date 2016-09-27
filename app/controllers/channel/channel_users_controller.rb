module Channel
  class ChannelUsersController < ChannelAdminController
    before_action :authenticate!

    def new

    end

    def create
      @channel_user = ChannelUser.new()
      @channel_user.name=params[:name]
      @channel_user.email=params[:email]
      @channel_user.phone=params[:phone]
      @channel_user.password=params[:password]
      @channel_user.district_id=params[:district]
      @channel_user.company=params[:type]

      if ChannelUser.find_by(phone: params[:phone]) || ChannelUser.find_by(email: params[:email])
        redirect_to :back, :notice => "邮箱或手机号已存在!"
        return false;
      end

      if @channel_user.save
        redirect_to :back, :notice => '添加成功'
      else
        redirect_to :back, :notice => '添加失败'
      end
    end

    def show
      @channel_user = ChannelUser.find(params[:id])
      @schools = @channel_user.channel_schools.where(:passed => true ).page(params[:page]).per(9)
    end
  end
end
