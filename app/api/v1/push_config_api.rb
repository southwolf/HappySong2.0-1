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
          current_user.add_push_action(PushAction.find_by(name: 'follow'))
        when 2
          current_user.add_push_action(PushAction.find_by(name:'comment'),PushAction.find_by(name: 'reply'))
        when 3
          current_user.add_push_action(PushAction.find_by(name:'like'))
        end
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
        present :message, result
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
          current_user.remove_push_action(PushAction.find_by(name: 'follow'))
        when 2
          current_user.remove_push_action(PushAction.find_by(name:'comment'),PushAction.find_by(name: 'reply'))
        when 3
          current_user.remove_push_action(PushAction.find_by(name:'like'))
        end
      end

    end
  end
end
