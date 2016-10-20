class Work < ActiveRecord::Base
  belongs_to :user, class_name: "User", foreign_key: "user_id"

  has_many   :work_to_teams
  has_many   :grade_team_classes, through: :work_to_teams

  has_many   :work_to_students
  has_many   :complete_works,   ->(){where(complete: true)},  class_name: "WorkToStudent"
  has_many   :uncomplete_works, ->(){where(complete: false)}, class_name: "WorkToStudent"
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
  after_commit :async_create_work_notify, on: :create

  def async_create_work_notify
    NotifyWorkJob.perform_later(id)
  end

  def self.push_work_notify(id)
    work = Work.find(id)
    result = []
    work.grade_team_classes.includes(:students).each do |grade_team_class|
       result +=grade_team_class.students
    end
    Notification.bulk_insert(set_size: 100) do |woker|
      result.each do |student|
        woker.add(
          { user_id: student.id,
            actor_id:   work.user.id,
            notice_type: 'work',
            targetable_type: work.class,
            targetable_id: work.id
           })
      end
    end


    #向所布置班级的学生推送作业发布通知

  end

  def complete_users
    result = []
    self.complete_works.includes(:student).each do |complete_work|
      result.push complete_work.student
    end
    return result
  end

  def uncomplete_users
    result = []
    self.uncomplete_works.includes(:student).each do |uncomplete_work|
      result.push uncomplete_work.student
    end
    return result
  end
end
