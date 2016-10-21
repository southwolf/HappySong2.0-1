module V1
  class NotificationApi < Grape::API
    include Grape::Kaminari
    paginate per_page: 20
    resources :notifications do

      desc "消息未读数"
      params do
        requires :token, type: String, desc: "用户令牌"
      end
      get '/unread' do
        authenticate!
        badge_follow  = Notification.unread_notify(current_user).where(notice_type: "follow").size
        badge_like    = Notification.unread_notify(current_user).where(notice_type: "like").select { |notification| notification.targetable.user == current_user}.size
        badge_comment = Notification.unread_notify(current_user).where(notice_type: "comment").select { |notification| notification.targetable.user == current_user}.size
        badge_work    = Notification.unread_notify(current_user).where(notice_type: "work").size

        result = {
          badge_follow:  badge_follow,
          badge_like:    badge_like,
          badge_comment: badge_comment,
          badge_work:    badge_work
        }

        present  result
      end
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
        present paginate(notifications), with: ::Entities::Notification
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
        notifications = notifications.select { |notification| notification.targetable.user == current_user}
        present paginate(Kaminari.paginate_array(notifications)), with: ::Entities::Notification
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
        notifications = notifications.select { |notification| notification.targetable.user == current_user}
        present paginate(Kaminari.paginate_array(notifications)), with: ::Entities::Notification
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
        notifications = Notification.where(user: current_user, notice_type: "work").order( created_at: :DESC)
        notifications = notifications.select { |notification| notification.targetable.user == current_user}
        present paginate(Kaminari.paginate_array(notifications)), with: ::Entities::NotificationWork
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
        notifications = Notification.where(user:current_user).order( created_at: :DESC)
        result = notifications.reject{ |notification| notification.user == notification.try(:targetable).try(:user)}
                              .reject { |notification| notification.notice_type = 'follow' && notification.user == current_user }
        # notifications.select{|notify| notify.targetable.user != current_user}
        present paginate(Kaminari.paginate_array(result)), with: ::Entities::Notification
      end
    end
  end
end
