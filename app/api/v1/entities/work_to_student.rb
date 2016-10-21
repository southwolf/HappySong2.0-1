module Entities
  class WorkToStudentOnlyStudent < Grape::Entity
    expose :student, using: ::Entities::SimpleUser
  end
  class WorkToStudent < WorkToStudentOnlyStudent
    expose :my_work, using: ::Entities::SimpleWork
    expose :complete, :created_at, :updated_at
  end
end
