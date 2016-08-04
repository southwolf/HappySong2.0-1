module V1
  module BaseHelpers
    extend Grape::API::Helpers
    def current_user
      token = params[:token].presence
      return nil unless token
      @current_user ||= User.find_by_auth_token(token.to_s)
    end

    def authenticate!
      error!({ error: "请登录!", detail: "请登录!" }, 401) unless current_user
    end

    def teacher_authenticate!
      authenticate!
      error!({ error: "你没有教师权限!", detail: "你没有教师权限!" }, 501) unless current_user.roles.first.name == "teacher"
    end

    def manager_authenticate!
      authenticate!
      error!({ error: "你没有管理员权限!", detail: "你没有管理员权限!" }, 501) unless current_user.roles.first.name == "manager"
    end

    def sign_in(user)
      token = User.new_token
      user.update_attribute(:token, User.encrypt(token))
      @current_user ||= user
    end

    def logout
      @current_user = nil
    end

    def set_code
      ([*?a..?z]+[*?1..?9]).sample(4).join
    end

    def set_id_code
      ([*?a..?z]+[*?1..?9]).sample(8).join
    end
  end
end
