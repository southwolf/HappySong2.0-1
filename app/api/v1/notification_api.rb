module V1
  class NotificationApi < Grape::API
    resources :notifications do
      desc "构建消息ID取消息信息"

      params do
        requires :id, type: Integer, desc: "信息ID"
      end
      get '/notice' do
        id = params[:id]
        notification = Notification.find(id)
        present notification, with: ::Entities::Notification
      end


      desc "获取用户所有未读消息"
      params do
        requires :token, type: String, desc: "用户令牌"
      end

      get '/all' do
        authenticate!
        notifications = Notification.unread.where(user: user)
        present notifications, ::Entities::Notification
      end
    end
  end
end
