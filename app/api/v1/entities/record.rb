module Entities
  class Record < Grape::Entity
    expose :id, :feeling, :style, :is_demo, :is_hot, :view_count, :comments_count, :likes_count, :created_at
    expose (:file_url) {|object| ENV['QINIUPREFIX']+object.file_url}
    expose :user,     using: Entities::User
    expose :music,    using: Entities::Music
    expose :article,  using: Entities::Article
    # expose :comments, using: Entities::CommentWithReply
  end
  class SimpleRecord < Grape::Entity
    expose :id, :feeling, :style, :is_demo, :is_hot, :view_count, :comments_count, :likes_count, :created_at
    expose :user, using: Entities::User
  end
end
