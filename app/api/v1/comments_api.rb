module V1
  class CommentsApi < Grape::API
    resources :comments do
      desc "回复评论"
      params do
        requires :token,   type: String,  desc: "用户访问令牌"
        requires :id,      type: Integer, desc: "评论的ID"
        requires :content, type: String,  desc: "回复内容"
      end
      post "/reply" do
        authenticate!
        id      = params[:id].to_i
        content = params[:content].to_s
        comment = Comment.find(id)

        reply = comment.replys.new(:content => content,
                                 :user_id => current_user.id,
                                 :commentable_id   => comment.commentable_id,
                                 :commentable_type => comment.commentable_type )

        if reply.save
          present :message, "成功"
        else
          error!("失败", 500)
        end
      end
    end
  end
end
