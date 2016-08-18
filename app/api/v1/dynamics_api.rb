module V1
  class DynamicsApi < Grape::API
    include Grape::Kaminari
    paginate per_page: 20

    resources :dynamics do
      desc "新建动态"
      params do
        # requires :token,       type: Integer,     desc: '用户访问令牌'
        requires :content,     type: String,      desc: '内容'
        group :attachments, type: Array do
          requires :key
          requires :is_video
        end
        requires :address, type: String,        desc: '地理位置'
        optional :tags,    type: Array[String], desc: '标签集合'
      end
      post "/create" do
        puts params[:tags].inspect
        # authenticate!
        # content = params[:content]
        # address = params[:address]
        # attachments = params[:attachments]
        # tags    = params[:tags]
        # dynamic = current_user.dynamics.build( :content => content,
        #                                        :address => address,
        #                                        :original_user_id => current_user.id)

        # if dynamic.save
        #   # 添加附件
        #   attachments.each do |attachment|
        #     dynamic.attachments.create(:file_url => attachment.key,
        #                                :is_video => attachment.is_video)
        #   end
        #   # 添加标签
        #   tags.each do |tag|
        #     dynamic.addTag(tag)
        #   end
        #   present dynamic, with: ::Entities::Dynamic
        # else
        #   error!("失败", 500)
        # end

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

    end
  end
end
