module V1
  class UsersApi < Grape::API
    include Grape::Kaminari

    resources :users do
      # 获取短信验证码接口
      # http://host/api/v1/users/getcode?phone=?
      # params
      # phone 用户所填的手机号码
      desc '获取手机验证码'
      params do
        requires :phone, type: String, desc: "手机号"
      end
      get '/getcode' do
        phone = params[:phone].to_s
        # user = User.find_by_phone(phone)
        # if user.blank?
        #   user = User.create(:phone => phone)
        # end
        user = User.find_or_create_by(phone: phone)
        if YunPian.deliver(user.phone)
          present :message, "成功"
        else
          error!({ error: "失败"}, 500)
        end
      end

      # desc "check用户是否注册"
      # params do
      #   requires :phone, type: String, desc: "手机号"
      # end
      # get '/check' do
      #   user = User.find_by(phone: params[:phone])
      #   if user.role.nil?
      #     present :message, false
      #   else
      #     present :message, true
      #   end
      # end
      # 登陆接口
      # http://host/api/v1/users/login?phone=?&&code=?
      # 返回用户信息
      desc "用户登录"
      params do
        requires :phone, type: String, desc: "手机号"
        requires :code,  type: String, desc: "验证码"
      end
      post '/login' do
        phone = params[:phone].to_s
        code  = params[:code].to_s

        user = User.find_by_phone(phone)
        if YunPian.verify(phone, code)
          present :user, user, with: ::Entities::User
          present :message, "登陆成功"
        else
          error!({message: "验证码错误"},403)
        end
      end

      # 登出接口
      #
      # 返回操作结果信息
      desc "退出登录"
      params do
        requires :token, type: String, desc: "用户登录令牌"
      end
      get '/logout' do
        authenticate!
        current_user.reset_auth_token!
      end



      # 设置角色接口
      # http://host/api/v1/users/setrole?token=?&&role=?
      # params
      # token 用户登录令牌
      # role  用户所选角色【0代表老师，1代表家长，2代表学生】
      # desc "设置角色"
      # params do
      #   requires :token, type: String, desc: "token"
      #   requires :role,  type: Integer, desc: "角色[0:老师,1:家长,2:学生]"
      # end
      #
      # post '/setrole' do
      #   authenticate!
      #
      #
      #   present current_user, with: ::Entities::User
      # end

      desc "更换头像"
      params do
        requires :token,  type: String, desc: "用户登录令牌"
        requires :avatar, type: String, desc: "用户头像"
      end
      post '/avatar' do
        authenticate!
        avatar = params[:avatar]
        if current_user.update(avatar: avatar)
          present :message, "成功"
        else
          error!({message: "失败"}, 500)
        end
      end


      desc  "完善用户信息"
      params do
        requires :token,  type: String,  desc: "token"
        requires :name,   type: String,  desc: "用户姓名"
        requires :sex,    type: String,  desc: "用户性别"
        optional :desc,   type: String,  desc: "个性签名"
        requires :role,   type: Integer, values:[0,1,2],  desc: "用户角色[老师:0, 家长:1, 学生: 2]"
      end
      post '/update_profile' do
        authenticate!
        name      = params[:name].to_s
        sex       = params[:sex].to_s
        role_id   = params[:role].to_i
        desc      = params[:desc].to_s || ""
        if current_user.update(name: name, sex: sex, desc: desc) && current_user.set_role( role_id )
          current_user.update(:is_first => false)
          present current_user, with: ::Entities::User
        else
          error!( {error: '更新失败'}, 500)
        end
      end

      desc "更新个人中心背景图片"
      params do
        requires :token,        type: String, desc: "token"
        requires :bg_image_url, type: String, desc: "背景图片key"
      end
      post '/update_bg_image' do
        authenticate!
        bg_image_url = params[:bg_image_url]
        if current_user.update( :bg_image_url => bg_image_url)
          present :message, "更新成功"
        else
          error!({error: "失败"}, 500)
        end
      end

      desc "检查是否关注对应用户"
      params do
        requires :token,   type: String,  desc: "token"
        requires :user_id, type: Integer, desc: "用户id"
      end

      get '/checkfollowed' do
        authenticate!
        user = User.find(params[:user_id])
        if current_user.followed? user
          present :status, true
        else
          present :status, false
        end
      end


      desc "关注用户"
      params do
        requires :token,   type: String,  desc: "token"
        requires :user_id, type: Integer, desc: "被关注用户id"
      end
      post'/follow' do
        authenticate!
        user = User.find(params[:user_id].to_i)
        present error!({ message: '你不能关注自己'}, 403) if current_user == user
        present error!({ message: '不能重复关注'}, 403) if current_user.followed? user
        if current_user.follow(user)
          Notification.create(
            user_id: user.id,
            actor_id: current_user.id,
            notice_type: "follow"
          )
          present :message, "关注成功"
          present :follow_size, user.followers.size
        else
          error!({ message: '关注失败'}, 500)
        end
      end

      desc "取消关注"
      params do
        requires :token,   type: String, desc: "token"
        requires :user_id, type: Integer, desc: "被关注用户的id"
      end

      post '/unfollow' do
        authenticate!
        user = User.find(params[:user_id])
        if current_user.unfollow(user)
          present :message, "取消关注成功"
          present :follow_size, user.followers.size
        else
          error!({message: '取消关注失败'}, 500)
        end
      end

      desc "根据用户名或者用户ID查询用户"
      params do
        optional :q, type: String, desc: "查询标识"
      end
      get '/find'do
        q = params[:q]
        user = User.all.take(10) if q.nil?
        user = User.where("name=? OR uid=?", q, q)
        # if user.blank?
        # error!({message:"没有查到对应用户"},404)
        # else
        present :user, user, with: ::Entities::User
        # end
      end

      desc "我的个人中心"
      params do
        requires :token, type: String, desc: "token"
      end
      get '/profile' do
        authenticate!
        puts current_user.name
        present :user, current_user, with: ::Entities::MyProfile
      end

      desc "进他人个人中心"
      params do
        optional :token, type: String, desc: "token"
        requires :user_id, type: Integer, desc: "用户ID"
      end
      get '/other_profile' do
        if params[:token].present?
          current_user = User.find_by(:auth_token => params[:token])
        else
        end
         user = User.find(params[:user_id])
         present :user, user, with: ::Entities::MyProfile
      end



      desc "父母关联子女"
      params do
        requires :token,    type: String, desc: '用户访问令牌'
        requires :child_id, type: Integer, desc: '子女Id'
      end

      post '/add_child' do
        authenticate!
        present :error, "你当前身份不是父母" unless current_user.role.try(:name) == "parent"
        child_id = params[:child_id]
        child    = User.find(child_id)
        if child.update(parent_id: current_user.id)
          present :message, "成功"
        else
          error!({ message: "失败"},500)
        end
      end
      desc "获取我喜欢的内容"
      params do
        requires :token, type: String, desc: "token"
      end
      paginate per_page: 20
      get '/mylikes' do
        authenticate!

        liked_records  = current_user.like_records.order(created_at: :desc).group_by { |record| DateTime.parse(record.created_at.to_s).strftime('%Y-%-m')}.to_a
        liked_dynamics = current_user.like_dynamics.order(created_at: :desc).group_by{ |dynamic| DateTime.parse(dynamic.created_at.to_s).strftime('%Y-%-m')}.to_a
        present :like_records,   paginate(Kaminari.paginate_array(liked_records)),  with: ::Entities::HashRecord
        present :liked_dynamics, paginate(Kaminari.paginate_array(liked_dynamics)), with: ::Entities::HashDynamic
      end

      desc "家长查询子女"
      params do
        requires :token, type: String, desc:"用户访问令牌"
      end

      get '/children' do
        authenticate!
        children = current_user.children
        present children, with: ::Entities::User
      end

      desc "获取我关注的用户"
      params do
        requires :token, type: String, desc:"用户令牌"
      end
      paginate per_page: 20
      get '/followers' do
        authenticate!
        followings = current_user.followings
        present paginate(followings), with: ::Entities::User
      end

      desc "获取关注我的用户"
      params do
        requires :token, type: String, desc:"用户令牌"
      end
      paginate per_page: 20
      get '/followings' do
        authenticate!
        followers = current_user.followers
        present paginate(followers), with: ::Entities::User
      end

      desc "获取我的同学"
      params do
        requires :token,    type: String, desc: '用户访问令牌'
      end
      paginate per_page: 20
      get '/my_classmate' do
        authenticate!
        myclassmates = current_user.classmates
        if myclassmates.nil?
          present  :message, "没有同学！请加入班级"
        else
          present  paginate(myclassmates),  with: ::Entities::User
        end
      end

      desc "子女查家长"
      params do
        requires :token, type: String, desc: "用户访问令牌"
      end

      get '/parent' do
        authenticate!
        parent = current_user.parent
        present parent, with: ::Entities::User
      end

      desc "查询返现总数据【教师】"
      params do
        requires :token, type: String, desc: "用户访问令牌"
      end

      get '/cash_data' do
        authenticate!
        invites_count = current_user.invites.count
        cash_backs    = current_user.try(:cash_back).try(:cash) || 0

        present :invites_count, invites_count
        present :cash_backs, cash_backs
      end

      desc "查询返现数据【教师】"
      params do
        requires :token, type: String, desc: "用户访问令牌"
        requires :years, type: Integer, desc: "年"
        requires :month, type: Integer, desc: "月"
      end
      get '/cash_backs' do
        authenticate!
        years = params[:years]
        month = params[:month]
        cash_managers = current_user.cash_managers.where("year(created_at) = ?", years)
                                                  .where("month(created_at) = ?", month)
        present :count_amount,  cash_managers.sum(:amount)
        present :cash_managers, cash_managers, with: ::Entities::CashManager
      end

      desc "查询返现的年月【教师】"
      params do
        requires :token, type: String, desc: "用户访问令牌"
      end
      get '/time' do
        authenticate!
        times = current_user.cash_managers.select(:created_at).distinct.to_a
        result = times.map { |time| time.created_at.strftime("%Y-%m") }.sort.reverse.uniq

        present result
      end

      desc "查询返现积分总数据【家长】"
      params do
        requires :token, type: String, desc: "用户访问令牌"
      end
      get '/credit_data' do
        authenticate!
        invites_count = current_user.invites.count
        credit_back   = current_user.try(:credit).try(:point) || 0

        present :invites_count, invites_count
        present :credit_back,   credit_back
      end

      desc "查询返现积分数据【家长】"
      params do
        requires :token, type: String, desc: "用户访问令牌"
        requires :years, type: Integer, desc: "年"
        requires :month, type: Integer, desc: "月"
      end
      get '/credit_back' do
        authenticate!
        years = params[:years]
        month = params[:month]
        credit_managers = current_user.credit_managers.where("year(created_at)=?", years)
                                                     .where("month(created_at)=?", month)
        present :count_amount, credit_managers.sum(:point)
        present :credit_managers, credit_managers, with: ::Entities::CreditManager
      end


      desc "查询返现积分年月【家长】"
      params do
        requires :token, type: String, desc: "用户访问令牌"
      end
      get '/time_parent' do
        authenticate!
        times = current_user.credit_managers.select(:created_at).distinct.to_a
        result = times.map { |time| time.created_at.strftime("%Y-%m") }.sort.reverse.uniq

        present result
      end
    end
      # desc "测试"
      # paginate per_page: 10
      # get '/all' do
      #   users = User.all.group_by{|user| DateTime.parse(user.created_at.to_s).strftime('%Y-%-m')}.to_a
      #   # users.each do |key, value|
      #     # present :"#{key}", value, with: ::Entities::User
      #   # end
      #   present paginate(Kaminari.paginate_array(users)), with: ::Entities::HashUser
      # end


      resources :advise do
        desc '用户建议'
        params do
          requires :token,   type: String,  desc: "token"
          requires :content, type: String,  desc: "建议内容"
          requires :contact, type: String,  desc: "联系方式"
        end
        post do
          authenticate!
          content = params[:content]
          contact = params[:contact]
          advise = current_user.advises.new(:content => content, :contact => contact)
          if advise.save
            present :message, "感谢你的反馈！"
          else
            error!({ error: "提交失败"}, 503)
          end
        end
      end

      resources :albums do
        desc '上传图片到相册'
        params do
          requires :token,    type: String,    desc: '用户令牌'
          requires :file_key, type: String,    desc: '图片名'
        end

        post '/upload' do
          authenticate!
          file_key = params[:file_key]
          album = current_user.albums.build( :file_url => file_key )
          if album.save!
            present message: "上传成功"
          else
            error!({ error: "上传失败"} , 500)
          end
        end

        desc '取我的相册'
        params do
          requires :token, type: String, desc: '用户访问令牌'
        end
        get '/my_albums' do
          authenticate!
          albums = current_user.albums
          present albums, with: ::Entities::Album
        end
      end
  end
end
