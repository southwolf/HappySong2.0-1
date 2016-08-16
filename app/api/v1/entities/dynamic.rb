module Entities
  class Dynamic < Grape::Entity
    expose :id,:content,:address,:is_relay, :created_at
    expose :user, using: Entities::User
    expose :attachments, using: Entities::Attachment

    expose :ref_dynamic, using: Entities::Dynamic, if: ->(object) { object.is_relay == true } do|object, options|
      options[:ref_dynamic]
    end
    expose :ref_user, using: ::Entities::SimpleUser, if: ->(object){ object.is_relay == true} do|object, options|
      options[:ref_user]
    end
    expose :original_user, using: ::Entities::SimpleUser, if: ->(object){ object.is_relay == true} do|object, options|
      options[:original_user]
    end

    expose :tag, using: Entities::Tag

  end
end
