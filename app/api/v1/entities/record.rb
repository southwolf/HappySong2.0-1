module Entities
  class Record < Grape::Entity
    expose :id, :feeling, :style, :is_demo, :is_hot, :view_count, :comments_count, :likes_count, :created_at
    expose (:file_url) {|object| ENV['QINIUPREFIX']+object.file_url}
    expose (:width) do |object|
      uri = URI(ENV['QINIUPREFIX']+object.file_url+'?imageInfo')
      res = ::Net::HTTP.get_response(uri)
      info = ::ActiveSupport::JSON.decode res.body
      info["width"]
    end
    expose (:height) do |object|
      uri = URI(ENV['QINIUPREFIX']+object.file_url+'?imageInfo')
      res = ::Net::HTTP.get_response(uri)
      info = ::ActiveSupport::JSON.decode res.body
      info["height"]
    end
    expose :user,     using: Entities::User
    expose :music,    using: Entities::Music
    expose :article,  using: Entities::Article
    # expose :comments, using: Entities::CommentWithReply
    # expose (:liked?) do |object, option|
    #   current_user = option[:current_user]
    #   if current_user.present?
    #     if object.like_users.include? current_user
    #       true
    #     else
    #       false
    #     end
    #   else
    #     false
    #   end
    # end
  end
  class SimpleRecord < Grape::Entity
    expose :id, :feeling, :style, :is_demo, :is_hot, :view_count, :comments_count, :likes_count, :created_at
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
