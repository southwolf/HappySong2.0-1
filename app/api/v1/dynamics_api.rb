module V1
  class DynamicsApi < Grape::API
    include Grape::Kaminari
    paginate per_page: 20

    resources :dynamics do
      desc "新建动态"
      params do
        requires :token,        type: String,       desc: '用户访问令牌'
        requires :content,      type: String,        desc: '内容'
        requires :address,      type: String,        desc: '地理位置'
        # optional :picture_keys, type: Array[String], desc: '图片集合'
        optional :video_key,    type: String
        optional :tags,         type: Array[String], desc: '标签集合'
      end
      post "/create" do
        authenticate!
        content      = params[:content]
        address      = params[:address]
        # picture_keys = params[:picture_keys]
        video_key    = params[:video_key]
        tags         = params[:tags]
        dynamic      = current_user.dynamics.build( :content => content,
                                               :address => address)
        if dynamic.save
          dynamic.update( :original_dynamic_id => dynamic.id)
          # if picture_keys.present?
          #   # 添加附件
          #   picture_keys.each do |picture_key|
          #     dynamic.attachments.create(:file_url => picture_key,
          #                                :is_video => false)
          #   end
          # end

          if video_key.present?
            dynamic.attachments.create( :file_url => video_key,
                                       :is_video => true)
          end

          if tags.present?
            # 添加标签
            tags.each do |tag|
              dynamic.addTag(tag)
            end
          end
          present dynamic, with: ::Entities::Dynamic,
                           current_user: current_user
        else
          error!("失败", 500)
        end

      end

      desc "用动态ID上传该动态的图片附件"
      params do
        requires :token, type: String, desc: "用户访问令牌"
        requires :dynamic_id, type: Integer, desc: "动态Id"
        requires :key,   type: String, desc: "图片key"
      end

      post '/upload_attachment' do
        authenticate!
        key = params[:key]
        dynamic_id = params[:dynamic_id]
        dynamic = Dynamic.find(dynamic_id)

        if dynamic.attachments.create(:file_url => key,
                                      :is_video => false)
          present :message, '成功'
        else
          error!({error: '上传失败'}, 500)
        end
      end

      desc "转发动态"
      params do
        requires :token,      type: String,        desc: "用户访问令牌"
        requires :dynamic_id, type: Integer,        desc: "动态ID"
        requires :content,    type: String,        desc: "内容"
        requires :tags,       type: Array[String], desc: "标签集合"
      end

      post "/forward" do
        authenticate!
        dynamic_id = params[:dynamic_id]
        content    = params[:content]
        tags       = params[:tags]
        dynamic = Dynamic.find(dynamic_id)
        ref_dynamic = dynamic.ref_dynamics.create(
                                     :user_id  => current_user.id,
                                     :content  => content,
                                     :is_relay => true,
                                     :original_dynamic_id => dynamic.original_dynamic_id)
        if ref_dynamic.save
          tags.each do |tag|
            ref_dynamic.addTag tag
          end
          present ref_dynamic, with: ::Entities::Dynamic
        else
          error!("失败",500)
        end
      end

      desc "查看动态"
      params do
        optional :token,      type: String, desc: '用户访问令牌'
        requires :dynamic_id, type: Integer, desc: '动态ID'
      end

      get '/show_dynaminc' do
        if params[:token].present?
          authenticate!
        else
          current_user = nil
        end
        
        dynamic_id = params[:dynamic_id]
        dynamic    = Dynamic.find(dynamic_id)
        present  dynamic, with: ::Entities::Dynamic,
                                current_user: current_user
      end

      desc "评论动态"
      params do
        requires :token,      type: String,  desc: '用户访问令牌'
        requires :dynamic_id, type: Integer, desc: '动态ID'
        requires :content,    type: String,  desc: '评论内容'
      end
      post '/comment' do
        authenticate!
        dynamic_id = params[:dynamic_id]
        content    = params[:content]
        dynamic    = Dynamic.find(dynamic_id)
        comment    = dynamic.comments.build( :user_id => current_user.id,
                                             :content => content)
        if comment.save
          present message: "评论成功"
        else
          error!({error: "评论失败"}, 500)
        end
      end

      desc "根据动态ID取评论列表"

      params do
        requires :dynamic_id, type: Integer, desc: '动态ID'
      end
      get '/comments' do
        dynamic_id = params[:dynamic_id]
        dynamic    = Dynamic.find(dynamic_id)
        comments   = dynamic.comments
        present paginate(comments), with: ::Entities::CommentWithReply
      end

      desc "点赞动态"
      params do
        requires :token,      type: String,  desc: '用户访问令牌'
        requires :dynamic_id, type: Integer, desc: '动态ID'
      end

      post '/like' do
        authenticate!
        dynamic_id = params[:dynamic_id]
        dynamic    = Dynamic.find(dynamic_id)

        if dynamic.like_users << current_user
          present message: "成功"
        else
          error!({message: "失败"}, 500)
        end
      end

      desc "取消点赞动态"
      params do
        requires :token,      type: String,  desc: "访问令牌"
        requires :dynamic_id, type: Integer, desc: "动态ID"
      end

      post '/unlike' do
        authenticate!

        dynamic_id = params[:dynamic_id].to_i
        dynamic    = Dynamic.find(dynamic_id)

        if dynamic.like_users.destroy current_user
          present message: "成功"
        else
          error!("失败",  500)
        end
      end

      desc "检查是否点赞"
      params do
        requires :token,      type: String,  desc: "用户访问令牌"
        requires :dynamic_id, type: Integer, desc: "动态ID"
      end

      get '/checklike' do
        authenticate!
        dynamic_id = params[:dynamic_id]
        dynamic    = Dynamic.find(dynamic_id)
        result     = dynamic.like_users.include?(current_user)
        if result
          present message: true
        else
          present message: false
        end
      end

      desc "按标签查询动态"
      params do
        requires :q, type: String, desc: "查询参数[标签名称]"
      end
      get '/tag_search' do
        q = params[:q]
        tag = Tag.find_by_name(q)

        if q.blank?
          dynamics = Dynamic.all.order_by(created_at: :DESC)
        else
          if tag.blank?
            error!({ message: "没有找到对应内容"}, 404)
          else
            dynamics = tag.dynamics
          end
        end
        present paginate(dynamics), with: ::Entities::Dynamic
      end

      desc "按照用户查询动态"
      params do
        optional :q,     type: String, desc: "用户名"
        optional :token, type: String, desc: "用户访问令牌"
      end
      get '/user_search' do
        if params[:token].present?
          authenticate!
        else
          current_user = nil
        end
        q = params[:q]
        user = User.find_by_name(q)
        if q.blank?
          dynamics = Dynamic.all.order(created_at: :DESC)
        else
          if user.blank?
            error!({message: "没有找到对应用户"},404)
          else
            dynamics = user.dynamics
          end
        end
        present paginate(dynamics), with: ::Entities::Dynamic,
                                          current_user: current_user
      end

      desc "按月分组取个人动态"
      params do
        requires :token, type: String, desc: "用户访问令牌"
      end
      get '/group' do
        authenticate!
        dynamics = current_user.dynamics.group_by{|dynamic| DateTime.parse(dynamic.created_at.to_s).strftime('%Y-%-m')}.to_a

        present paginate(Kaminari.paginate_array(dynamics)), with: ::Entities::HashDynamic
      end

      desc "获取好友动态"
      params do
        requires :token, type: String, desc: "用户访问令牌"
      end
      get '/friend_dynamics' do
        authenticate!
        follwing_users = current_user.following_users
        dynamics = []
        follwing_users.each do |user|
          dynamics << user.dynamics
        end
        dynamics = dynamics.flatten.sort_by {|dynamic| dynamic.created_at}.reverse
        present paginate(Kaminari.paginate_array(dynamics)), with: Entities::Dynamic,
                                                                   current_user: current_user
      end


      desc "获取好友动态按月分组"
      params do
        requires :token,   type: String, desc: "用户访问令牌"
        requires :user_id, type: Integer, desc: "好友Id"
      end
      get '/other_group_dynamics' do
        authenticate!
        user = User.find(params[:user_id])
        other_dynamics = user.dynamics.group_by{ |dynamic| DateTime.parse(dynamic.created_at.to_s).strftime('%Y-%-m')}.to_a
        present paginate(Kaminari.paginate_array(other_dynamics)), with: ::Entities::HashDynamic
      end

      desc "获取所有动态"
      params do
        optional :token, type: String, desc: '用户访问令牌'
      end
      get '/all' do
        if params[:token].present?
          authenticate!
        else
          current_user = nil
        end
        dynamics = Dynamic.not_relay.order( created_at: :DESC)
        present paginate(dynamics), with: ::Entities::Dynamic,
                                          current_user: current_user
      end

      desc "根据时间查动态"
      params do
        requires :token,   type: String,  desc: "用户访问令牌"
        optional :user_id, type: Integer, desc: "用户ID"
        requires :time,    type: String,  desc: "时间"
      end
      get '/time_dynamics' do
        authenticate!
        user_id = params[:user_id]
        time    = params[:time]
        if user_id.nil?
          dynamics = current_user.dynamics.select {|dynamic| DateTime.parse(dynamic.created_at.to_s).strftime('%Y-%-m') == time }
          present paginate(Kaminari.paginate_array(dynamics)), with: ::Entities::Dynamic
        else
          user = User.find(user_id)
          dynamics = user.dynamics.reject { |dynamic| DateTime.parse(dynamic.created_at.to_s).strftime('%Y-%-m') != time}
          present paginate(Kaminari.paginate_array(dynamics)), with: ::Entities::Dynamic
        end
      end

      desc "根据动态ID获取动态的评论"
      params do
        requires :dynamic_id, type: Integer, desc: "动态Id"
      end
       get '/comments' do
        dynamic = Dynamic.find(params[:dynamic_id])
        comments = dynamic.comments.order(created_at: :DESC)
        present paginate(comments), with: ::Entities::CommentWithReply
      end

      desc "举报动态"
      params do
        requires :token,      type: String,  desc: "用户访问令牌"
        requires :dynamic_id, type: Integer, desc: "动态ID"
      end
      post '/report' do
        authenticate!
        dynamic_id = params[:dynamic_id]
        dynamic = Dynamic.find(dynamic_id)
        if dynamic.reports.create(:user_id => current_user.id)
          present :message, "举报成功"
        else
          error!({error: "失败"}, 500)
        end
      end
    end
  end
end
