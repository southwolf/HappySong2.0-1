module Entities
  class TeamClass < Grape::Entity
    # expose :code
    expose :id, :code
    expose :user, using: Entities::User
  end
end
