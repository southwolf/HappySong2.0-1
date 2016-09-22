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


      desc "获取用户粉丝消息"
      params do
        requires :token, type: String, desc: "用户令牌"
      end

      get '/follow' do
        authenticate!
        notifications = Notification.where(user: current_user, notice_type: "follow").order( created_at: :DESC)
        present paginate(notifications), ::Entities::Notification
        notifications.each do |notification|
          notification.update(unread: false)
        end
      end

      desc "获取用户喜欢消息"
      params do
        requires :token, type: String, desc: "用户令牌"
      end

      get '/like' do
        authenticate!
        notifications = Notification.where(user: current_user, notice_type: "like").order( created_at: :DESC)
        present paginate(notifications), with: ::Entities::Notification
        notifications.each do |notification|
          notification.update(unread: false)
        end
      end

      desc "获取用户评论消息"
      params do
        requires :token, type: String, desc: "用户令牌"
      end

      get '/comment' do
        authenticate!
        notifications = Notification.where(user: current_user, notice_type: "comment").order( created_at: :DESC)
        present paginate(notifications), with: ::Entities::Notification
        notifications.each do |notification|
          notification.update(unread: false)
        end
      end

      desc "获取用户作业消息"
      params do
        requires :token, type: String, desc: "用户令牌"
      end

      get '/work' do
        authenticate!
        notifications = Notification.where(user: user, notice_type: "work").order( created_at: :DESC)
        present paginate(notifications), with: ::Entities::Notification
        notifications.each do |notification|
          notification.update(unread: false)
        end
      end

      desc "获取官方通知消息"
      params do
        requires :token, type: String, desc: "用户令牌"
      end

      get '/announce' do
        authenticate!
        notifications = Notification.where(user: current_user, notice_type: "announce").order( created_at: :DESC)
        present paginate(notifications), with: ::Entities::Notification
      end


      desc "获取动态消息"
      params do
        requires :token, type: String, desc: "用户令牌"
      end

      get '/notify' do
        authenticate!
        notifications = Notification.where(user:current_user).where.not(targetable: current_user).order( created_at: :DESC)
        present paginate(notifications), with: ::Entities::Notification
      end
    end
  end
end
