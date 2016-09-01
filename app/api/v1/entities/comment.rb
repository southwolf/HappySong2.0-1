module Entities
  class Comment < Grape::Entity
    expose :id, :content, :created_at
    expose :user, using: ::Entities::User
  end

  class CommentWithReply < Comment
    expose :own_replys, using: ::Entities::Reply
  end

  class Relpy < Grape::Entity
    expose :id, :content, :created_at
    expose :user,    using: Entities::User
    expose :top_comment_user, using: Entities::User do |object|
      object.origin_comment.user
    end
  end
end
