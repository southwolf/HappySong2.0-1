module Entities
  class WorkToStudentOnlyStudent < Grape::Entity
    expose :student, using: ::Entities::SimpleUser
  end
end
