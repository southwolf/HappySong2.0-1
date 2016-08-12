module Entities
  class Record < Grape::Entity
    expose :id, :feeling, :style, :created_at
    expose (:file_url) {|object| ENV['QINIUPREFIX']+object.file_url}
    expose :user,     using: Entities::User
    expose :music,    using: Entities::Music
    expose :article,  using: Entities::Article
    expose :comments, using: Entities::Comment
    expose (:likes_count) { |object| object.like_users.size}
  end
end
