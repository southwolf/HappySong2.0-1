module Entities
  class Dynamic < Grape::Entity
    expose :id,:content,:address,:is_relay, :created_at
    expose :user, using: Entities::User
    expose :attachments, using: Entities::Attachment

    expose (:ref_dynamic_id) do |object|
      if object.ref_dynamic_id.blank?
        ""
      else
        object.ref_dynamic_id
      end
    end

    expose (:ref_user_id) do |object|
      if object.ref_user_id.blank?
        ""
      else
        object.ref_user_id
      end
    end

    expose :original_user_id

    expose :tag, using: Entities::Tag

  end
end
