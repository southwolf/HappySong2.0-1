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
        present :message, "没有找到" if notification.blank?
        present notification, with: ::Entities::Notification
      end


      desc "获取所有未读消息"

      get '/all' do
        notifications = Notification.unread
        present notifications, ::Entities::Notification
      end
    end
  end
end
