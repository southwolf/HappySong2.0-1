module Entities
  class Comment < Grape::Entity
    expose :id, :content, :created_at
    expose :user, using: ::Entities::User
  end

  class CommentWithReply < Comment
    expose :replys, using: ::Entities::Reply do |object|
      object.own_replys
    end
  end

  class Relpy < Grape::Entity
    expose :id, :content, :created_at
    expose :user,    using: Entities::User
    expose :top_comment_user, using: Entities::User do |object|
      object.origin_comment.user
    end
  end
end
