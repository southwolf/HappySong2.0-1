class Work < ActiveRecord::Base
  belongs_to :teacher, class_name: "User", foreign_key: "user_id"

  has_many   :work_to_teams
  has_many   :grade_team_classes, through: :work_to_teams

  has_many   :work_to_students
  has_many   :students, class_name: "User",
                        through: :work_to_students

  has_many   :work_to_articles
  has_many   :articles, through: :work_to_articles

  has_many  :work_attachments

  #朗读作业
  has_many  :complete_record_works,   class_name: "Record"

  #创作作业
  has_many  :complete_creative_works, class_name: "Dynamic"
  has_many  :comments, as: :commentable


end
