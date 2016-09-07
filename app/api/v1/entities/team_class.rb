module Entities
  class TeamClass < Grape::Entity
    expose :id, :name
  end
  class GradeTeamClass < Grape::Entity
    expose :id, :code
    expose :teacher, using: Entities::User
    expose :school,  using: Entities::School
    expose :grade,   using: Entities::Grade
    expose :students, using: Entities::User
  end
end
