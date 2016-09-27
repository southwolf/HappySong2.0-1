module Channel
  class SchoolController < ChannelAdminController
    before_action :authenticate!

    def new

    end

    def show
      @school = School.find(params[:id])
      @year=Time.new.year
      @month=Time.new.month
    end

    def show_ajax
      @date = params[:date]
      @type = params[:type]
      @tmptime = Time.parse(@date);

    end

    #报备学校
    def addSchool
      ids=params[:ids]

      result=JSON.parse(ids)

      result.each do |res|
        n = ChannelSchool.new(channel_user_id: @current_user.id, school_id: res)
        n.save
      end

      render(:json => 'ok', :layout => false)
    end


    #学校是否已报备
    def checkSchool
      school_id=params[:school_id]
      if ChannelSchool.find_by(school_id: school_id)
        render(:json => 'yes', :layout => false)
      else
        render(:json => 'no', :layout => false)
      end
    end

    #添加新学校
    def schoolAdd
      district = District.find(params[:district_id])

      if School.find_by(name: params[:name], district_id: params[:district_id])
        render(:json => 'token', :layout => false)
        return false;
      end

      school = district.schools.build(:name => params[:name])
      if school.save
        render(:json => school.id, :layout => false)
      else
        render(:json => 'fail', :layout => false)
      end

    end

    #申请提现
    def apply_cash_ajax
      amount= params[:amount].to_i
      apply = @current_user.apply_cash_backs.build
      apply.amount=params[:amount].to_i
      apply.alipay=params[:alipay]
      if apply.save
        @cash = @current_user.channel_user_cash_back
        @cash.amount  -= amount
        @cash.used  += amount
        @cash.save
        render(:json => 'success', :layout => false)
      else
        render(:json => 'fail', :layout => false)
      end
    end
  end
end
