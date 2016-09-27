module Entities
  class Record < Grape::Entity
    expose :id, :feeling, :style, :is_demo, :is_hot, :view_count, :comments_count, :likes_count, :created_at, :is_public
    expose (:file_url) {|object| ENV['QINIUPREFIX']+object.file_url}
    expose :user,     using: Entities::SimpleUser
    # expose :music,    using: Entities::Music
    expose :article,  using: Entities::Article
    expose (:share_url) {|object| ENV['SHARERECORD']+"/share_record/#{object.id}"}
    # expose :comments, using: Entities::CommentWithReply
  end
  class SimpleRecord < Grape::Entity
    expose :id, :feeling, :style, :is_demo, :is_hot, :view_count, :comments_count, :likes_count, :created_at,:is_public
    expose :user, using: Entities::User
  end

  class HashRecord < Grape::Entity
    expose (:time) { |object| object[0] }
    expose (:size) { |object| object[1].size}
    expose :records, using: Entities::Record do |object|
      object[1]
    end
  end
end
