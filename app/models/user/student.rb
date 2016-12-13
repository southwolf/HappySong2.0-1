class Student < User

  # associations
  has_many :class_students, foreign_key: :student_id, class_name: 'ClassStudent'
  has_many :org_classes, through: :class_students # 学生可以加入多个班级

  has_many :student_works, foreign_key: :student_id, class_name: 'StudentWork'
  has_many :home_works, through: :student_works

  # instance methods
  def join_class(org_class) # 加入班级
    class_student = class_students.build(org_class: org_class)
    begin
      class_student.save
    rescue
      return nil
    end
  end

  # TODO 日后还是使用 SoftDelete 比较好
  def quit_class(org_class) # 学生可以退出某个班级
    class_student = class_students.find_by(org_class: org_class)
    class_student.destroy if class_student
  end

end
