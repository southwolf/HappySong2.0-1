module Entities
  class Comment < Grape::Entity
    expose :user,    using: Entities::User
    expose :content, :created_at
  end
  
  class CommentWithReply < Comment
    expose :replys, using: ::Entities::Reply
  end

  class Relpy < Grape::Entity
    expose :content, :created_at
    expose :user,    using: Entities::User
  end
end
