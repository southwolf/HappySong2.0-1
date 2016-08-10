module Entities
  class TeamClass < Grape::Entity
    expose :id, :code
    expose :user, using: Entities::User
  end
end
