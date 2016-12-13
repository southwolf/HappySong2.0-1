class CreateStudentWorkJob < ApplicationJob
  queue_as :callbacks

  def perform(class_work_id)
    class_work = ClassWork.find_by(id: class_work_id)
    class_work.org_class.students.pluck(:id).each do |stu_id|
      begin # 这里避免了一个同学在两个班级的时候同时收到了同一份作业的尴尬
        StudentWork.create(work_id: home_work.id, student_id: stu_id, state: 0)
      rescue =>
        nil
      end
    end if class_work
  end
end
