class WorkToTeam < ActiveRecord::Base
  belongs_to :work
  belongs_to :grade_team_class

  after_create :work_to_students

  def work_to_students
    self.grade_team_class.students.each do |student|
      #如果学生是vip就将作业任务加入表中
      if student.vip?
        student.my_works << self.work
      end
    end
  end
end
