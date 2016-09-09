module Entities
  class Notification < Grape::Entity
    expose :id, :notice_type
    expose :actor,using: ::Entities::User

    expose   :targetable_id, :targetable_type, :second_targetable, :second_targetable_type
    # expose :targetable, using: ::Entities::User, if: ->(object, option) { object.targetable.class == User}
    # expose :targetable, using: ::Entities::Record, if: ->(object, option) { object.targetable.class == Record}
    # expose :targetable, using: ::Entities::Dynamic, if: ->(object, option) { object.targetable.class == Dynamic}
    # expose :targetable, using: ::Entities::Comment, if: ->(object, option) { object.targetable.class == Comment}
    #
    # expose :second_targetable, using: ::Entities::User, if: ->(object, option){ object.second_targetable.class == User}
    # expose :second_targetable, using: ::Entities::Record, if: ->(object, option){ object.second_targetable.class == Record}
    # expose :second_targetable, using: ::Entities::Dynamic, if: ->(object, option){ object.second_targetable.class == Dynamic}
    # expose :second_targetable, using: ::Entities::Comment, if: ->(object, option){ object.second_targetable.class == Comment}
  end
end
