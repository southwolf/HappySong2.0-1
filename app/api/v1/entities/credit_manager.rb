module Entities
  class CreditManager < Grape::Entity
    expose :id, :point
    expose :target_user, using: ::Entities::InviteUser
  end
end
