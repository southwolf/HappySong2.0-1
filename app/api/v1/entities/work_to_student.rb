module Entities
  class WorkToStudentOnlyStudent < Grape::Entity
    expose :student, using: ::Entities::SimpleUser
  end
  class WorkToStudent < WorkToStudentOnlyStudent
    expose :work, using: ::Entities::Work
    expose :complete, :created_at
  end
end
