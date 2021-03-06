module Entities
  class Reply < Grape::Entity
    expose :id, :content, :created_at
    expose :user, using: Entities::User
    expose :reply_user, using: Entities::User do |object|
      object.root.user
    end
  end
end
