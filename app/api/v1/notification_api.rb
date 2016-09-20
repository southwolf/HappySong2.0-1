module V1
  class NotificationApi < Grape::API
    include Grape::Kaminari
    paginate per_page: 20
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


      desc "获取用户粉丝未读消息"
      params do
        requires :token, type: String, desc: "用户令牌"
      end

      get '/follow' do
        authenticate!
        notifications = Notification.where(user: current_user, notice_type: "follow")
        present paginate(notifications), ::Entities::Notification
        notifications.each do |notification|
          notification.update(unread: false)
        end
      end

      desc "获取用户喜欢未读消息"
      params do
        requires :token, type: String, desc: "用户令牌"
      end

      get '/like' do
        authenticate!
        notifications = Notification.where(user: current_user, notice_type: "like")
        present paginate(notifications), with: ::Entities::Notification
        notifications.each do |notification|
          notification.update(unread: false)
        end
      end

      desc "获取用户评论未读消息"
      params do
        requires :token, type: String, desc: "用户令牌"
      end

      get '/comment' do
        authenticate!
        notifications = Notification.where(user: current_user, notice_type: "comment")
        present paginate(notifications), with: ::Entities::Notification
        notifications.each do |notification|
          notification.update(unread: false)
        end
      end

      desc "获取用户作业未读消息"
      params do
        requires :token, type: String, desc: "用户令牌"
      end

      get '/work' do
        authenticate!
        notifications = Notification.where(user: user, notice_type: "work")
        present paginate(notifications), with: ::Entities::Notification
        notifications.each do |notification|
          notification.update(unread: false)
        end
      end

      desc "获取官方通知未读消息"
      params do
        requires :token, type: String, desc: "用户令牌"
      end

      get '/announce' do
        authenticate!
        notifications = Notification.where(user: current_user, notice_type: "announce")
        present paginate(notifications), with: ::Entities::Notification
      end
    end
  end
end
