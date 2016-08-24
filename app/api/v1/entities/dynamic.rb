module Entities
  class SimpleDynamic < Grape::Entity
    expose :id, :content, :address, :likes_count
    expose :attachments, using: Entities::Attachment
  end

  class Dynamic < SimpleDynamic
    expose :is_relay, :comments_count, :created_at
    expose :user,                    using: Entities::User
    expose :attachments,             using: Entities::Attachment
    expose :root_dynamic,            using: Entities::SimpleDynamic

    expose (:root_dynamic_user),     using: Entities::SimpleUser do |object|
      object.root_dynamic.try(:user)
    end

    expose (:original_dynamic_user), using: Entities::SimpleUser do |object|
      object.original_dynamic.try(:user)
    end
    expose :tags,                     using: Entities::Tag
    expose (:url) do |object|
      "http:://localhost:3000/#{object.id}"
    end
  end

  class HashDynamic < Grape::Entity
    expose (:time ) { |object| object[0]}
    expose (:size)  { |object| object[1].size}
    expose :dynamics, using: Entities::Dynamic do |object|
      object[1]
    end
  end
end
