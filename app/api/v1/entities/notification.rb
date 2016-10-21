module Entities
  class Notification < Grape::Entity
    expose :id, :notice_type
    expose :user,              using: ::Entities::User
    expose :actor,             using: ::Entities::User
    expose :targetable,        using: ::Entities::Targetable
    expose :second_targetable, using: ::Entities::Targetable
    expose :created_at
  end

  class NotificationWork < Grape::Entity
    expose :id, :notice_type
    expose :user,              using: ::Entities::User
    expose :actor,             using: ::Entities::User
    expose :targetable,        using: ::Entities::Work
    expose :second_targetable, using: ::Entities::Targetable
    expose :created_at
  end
end
