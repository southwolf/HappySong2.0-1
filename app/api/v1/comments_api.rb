module V1
  class CommentsApi < Grape::API
    resources :comments do
      desc "回复评论"
      params do
        requires :token,             type: String,  desc: "用户访问令牌"
        requires :id,                type: Integer, desc: "评论/回复的ID"
        requires :top_comment_id,    type: Integer, desc: "顶层评论ID"
        requires :content,           type: String,  desc: "回复内容"
      end
      post "/reply" do
        authenticate!
        id      = params[:id].to_i
        content = params[:content].to_s
        top_comment_id = params[:top_comment_id].to_i
        comment = Comment.find(id)

        reply = comment.replys.new(:content           => content,
                                   :user_id           => current_user.id,
                                   :top_comment_id    => top_comment_id,
                                   :commentable_id    => comment.commentable_id,
                                   :commentable_type  => comment.commentable_type,
                                   :is_reply          => true )

        if reply.save
          present :message, "成功"
        else
          error!("失败", 500)
        end
      end


      desc "通过ID查评论"
      params do
        requires :token, type: String,  desc: "用户访问令牌"
        requires :id,    type: Integer, desc: "评论/回复的ID"
      end

      get '/comment' do
        comment = Comment.find(params[:id])
        present comment, with: ::Entities::Comment
      end
    end
  end
end
