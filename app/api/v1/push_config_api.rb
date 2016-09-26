module V1
  class PushConfigAPi < Grape::API
    resources :push_config do
      desc "关闭接受指定消息"
      params do
        requires :token,  type: String, desc: "用户登录令牌"
        requires :notify, type: Integer, desc: "消息类型自己传ID [新粉丝: 1, 评论: 2, 喜欢: 3]"
      end
      post '/colse' do
        authenticate!
        notify = params[:notify]
        case notify
        when 1
          current_user.add_push_action(PushAction.find_by(action: 'follow'))
        when 2
          current_user.add_push_action(PushAction.find_by(action:'comment'),PushAction.find_by(action: 'reply'))
        when 3
          current_user.add_push_action(PushAction.find_by(action:'like'))
        end

        message = true
        present :message, message

      end


      desc "检查是否关闭指定消息"
      params do
        requires :token,  type: String, desc: "用户登录令牌"
      end
      post '/check' do
        authenticate!
        result = {
          follow: false,
          comment: false,
          like: false
        }
        if current_user.push_actions.present?
          current_user.push_actions do |push_action|
            case push_action.action
            when "follow"
              result.merger({follow:true})
            when "comment","reply"
              result.merger({comment: true})
            when "like"
              result.merger({comment: true})
            end
          end
        end
        present result
      end


      desc "开启接受指定消息"
      params do
        requires :token,  type: String, desc: "用户登录令牌"
        requires :notify, type: Integer, desc: "消息类型自己传ID [新粉丝: 1, 评论: 2, 喜欢: 3]"
      end
      post '/open' do
        authenticate!
        notify = params[:notify]
        case notify
        when 1
          current_user.remove_push_action(PushAction.find_by(action: 'follow'))
        when 2
          current_user.remove_push_action(PushAction.find_by(action:'comment'),PushAction.find_by(action: 'reply'))
        when 3
          current_user.remove_push_action(PushAction.find_by(action:'like'))
        end
      end
      message = true
      present :message, message
    end
  end
end
