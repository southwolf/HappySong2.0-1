module V1
  class DynamicsApi < Grape::API
    include Grape::Kaminari
    paginate per_page: 20

    resources :dynamics do
      desc "新建动态"
      params do
        requires :token,        type: Integer,       desc: '用户访问令牌'
        requires :content,      type: String,        desc: '内容'
        requires :address,      type: String,        desc: '地理位置'
        optional :picture_keys, type: Array[String], desc: '图片集合'
        optional :video_key,    type: String
        optional :tags,         type: Array[String], desc: '标签集合'
      end
      post "/create" do
        authenticate!
        content      = params[:content]
        address      = params[:address]
        picture_keys = params[:picture_keys]
        video_key    = params[:video_key]
        tags         = params[:tags]
        dynamic      = current_user.dynamics.build( :content => content,
                                               :address => address,
                                               :original_user_id => current_user.id)

        if dynamic.save
          if picture_keys.present?
            # 添加附件
            picture_keys.each do |picture_key|
              dynamic.attachments.create(:file_url => picture_key,
                                         :is_video => false)
            end
          end

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
          present dynamic, with: ::Entities::Dynamic
        else
          error!("失败", 500)
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
        ref_dynamic = dynamic.ref_dynamics.create( :user_id  => current_user.id,
                                     :content  => content,
                                     :is_relay => true,
                                     :original_dynamic_id => dynamic.original_dynamic_id)
        if ref_dynamic.save
          tags.each do |tag|
            ref_dynamic.addTag tag
          end
          present ref_dynamic, with: ::Entities::Dynamoc
        else
          error!("失败",500)
        end
      end

      desc "评论动态"
      params do
        requires :token,      type: String,  desc: '用户访问令牌'
        requires :dynamic_id, type: Integer, desc: '动态ID'
        requires :content,    type: String,  desc: '评论内容'
      end
      post '/comments' do
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
        optional :q, type: String, desc: "查询参数"
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
        optional :q, type: String, desc: "用户名"
      end

      get '/user_search' do
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
        present paginate(dynamics), with: ::Entities::Dynamic
      end

      desc "按月分组取动态"
      get '/all' do
        dynamics = Dynamic.all.group_by{|dynamic| DateTime.parse(dynamic.created_at.to_s).strftime('%y-%m')}.to_a

        present dynamics, with: ::Entities::HashDynamic
      end
    end
  end
end
