module V1
  class UsersApi < Grape::API
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
        user = User.find_by_phone(phone)
        if user.blank?
          user = User.create(:phone => phone)
        end
        if user.deliver
          present :message, "成功"
        else
          error!("失败", 500)
        end
      end


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
        if user.verify code
          present :user, user, with: ::Entities::User
          present :message, "登陆成功"
        else
          error!("验证码错误",500)
        end
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
        requires :role,   type: Integer, desc: "用户角色[老师:0, 家长:1, 学生: 2]"
      end
      post '/update_profile' do
        authenticate!
        name      = params[:name].to_s
        sex       = params[:sex].to_s
        role_id   = params[:role].to_i
        if current_user.update(name: name, sex: sex) && current_user.set_role( role_id )
          present current_user, with: ::Entities::User
        else
          error!( '更新失败', 500)
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
      post '/follow' do
        authenticate!
        user = User.find(params[:user_id])
        present error!({message: '你不能关注自己'}, 500) if current_user == user
        if current_user.follow(user)
          present :message, "关注成功"
          present :follow_size, user.followers.size
        else
          error!({message: '关注失败'}, 500)
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
          status 200
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
        present :user, user, with: ::Entities::SimpleUser
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

      #
      # desc "测试"
      # get '/all' do
      #   users = User.all.group_by{|user| DateTime.parse(user.created_at.to_s).strftime('%y-%m')}
      #   users.each do |key, value|
      #     # present :key,   key
      #     # present :users, value, with: ::Entities::User
      #   end
      #   # present users, with: ::Entities::User
      # end
    end

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
          present :message, "感想你的反馈！"
        else
          error!({ error: "提交失败"}, 503)
        end
      end
    end
    

  end
end
