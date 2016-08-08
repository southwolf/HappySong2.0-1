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

        if user.nil?
          user = User.create(:phone => phone)
        end

        if user.deliver
          present :message, "成功"
          status 200
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
          status 200
        else
          error!("验证码错误",500)
        end
      end

      # 设置角色接口
      # http://host/api/v1/users/setrole?token=?&&role=?
      # params
      # token 用户登录令牌
      # role  用户所选角色【0代表老师，1代表家长，2代表学生】
      desc "设置角色"
      params do
        requires :token, type: String, desc: "token"
        requires :role,  type: Integer, desc: "角色[0:老师,1:家长,2:学生]"
      end

      post '/setrole' do
        authenticate!
        role = params[:role].to_i
        case role
        when 0
          current_user.add_role 'teacher'
        when 1
          current_user.add_role 'parent'
        when 2
          current_user.add_role 'student'
        else

        end

        present current_user, with: ::Entities::User
        status 200
      end

      desc "更换头像"
      params do
        requires :avatar, type: String, desc: "用户头像"
      end
      post '/avatar' do
        authenticate!
        avatar = params[:avatar]
        if current_user.update_attributes(avatar: avatar)
          present :message, "成功"
          status 200
        else
          error!({message: "失败"}, 500)
        end
      end


      desc  "更新角色"
      params do
        requires :token,  type: String,  desc: "token"
        requires :name,   type: String,  desc: "用户姓名"
        requires :age,    type: Integer, desc: "用户年龄"
        requires :sex,    type: String,  desc: "用户性别"
        optional :desc,   type: String,  desc: "用户简介"
        # optional :avatar, type: String, desc: "用户头像 "
      end
      post '/update_profile' do
        authenticate!
        name   = params[:user].to_s
        age    = params[:age].to_i
        sex    = params[:sex].to_s
        desc   = params[:desc].to_s
        # avatar = params[:avatar].nil? ? "happysong_logo.jpg": params[:avatar].to_s
        if current_user.update_attributes(name: name, age: age, sex: sex, desc: desc)
          present current_user, with: ::Entities::Simpleuser
          status 200
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
          status 200
        else
          present :status, false
          status 200
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
          status 200
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

      desc "根据用户名查询用户"
      params do
        requires :name, type: String, desc: "用户名"
      end
      get '/find'do
        name = params[:name]
        user = User.find_by_name(name)
        if user.nil?
          error!({message:"没有查到对应用户"},404)
        else
          present user, with: ::Entities::SimpleUser
          status 200
        end
      end

      desc "我的个人中心"
      params do
        requires :token, type: String, desc: "token"
      end
      get '/profile' do
        authenticate!
        puts current_user.name
        present :user, current_user, with: ::Entities::MyProfile
        status 200
      end

      desc "测试"
      get '/all' do
        users = User.all.group_by{|user| DateTime.parse(user.created_at.to_s).strftime('%y-%m')}
        users.each do |key, value|
          status 200
          # present :key,   key
          # present :users, value, with: ::Entities::User
        end
        # present users, with: ::Entities::User
      end
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
          status 200
        else
          error!({ error: "提交失败"}, 503)
        end
      end
    end


  end
end
