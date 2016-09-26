module Entities
  class CashManager < Grape::Entity
    expose :id, :amount
    expose :target_user, using: ::Entities::InviteUser
  end
end
