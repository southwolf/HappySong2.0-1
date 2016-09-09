module Entities
  class Notification < Grape::Entity
    expose :id, :notice_type
    expose :actor,using: ::Entities::User

    expose   :targetable_id, :targetable_type, :second_targetable, :second_targetable_type
  end
end
