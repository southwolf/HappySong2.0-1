module V1
  class UsersApi < Grape::API
    resources :channel_users do
      desc "获取验证码"
      params do
        requires :phone, type: String, desc: "手机号"
      end
      get '/getcode' do
        phone = params[:phone].to_s
        if YunPian.deliver(phone)
          present :message, "发送成功"
        else
          error!({ message: "失败"}, 500)
        end
      end
    end
  end
end
