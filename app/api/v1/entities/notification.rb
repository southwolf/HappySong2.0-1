module Entities
  class Notification < Grape::Entity
    expose :id, :notice_type
    expose :actor,using: ::Entities::User
    expose :targetable, using: ::Entities::Targetable
    expose :second_targetable_id, :second_targetable_type, :created_at
  end
end
