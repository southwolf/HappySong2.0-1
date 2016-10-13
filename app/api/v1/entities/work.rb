module Entities
  class Work < Grape::Entity
    expose :id, :content, :style, :comment_count,:start_time, :end_time
    expose :teacher,   :students,  using: ::Entities::SimpleUser
    expose :grade_team_classes,    using: ::Entities::GradeTeamClass
    expose :articles,              using: ::Entities::SimpleArticle
    expose :work_attachments,      using: ::Entities::Attachment
  end
end
