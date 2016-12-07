class Student < User

  # associations
  has_many :class_students, foreign_key: :student_id, class_name: 'ClassStudent'
  has_many :org_classes, through: :class_students # 学生可以加入多个班级

  # instance methods
  def join_class(class_code) # 加入班级
    org_class = Org::Class.find_by(code: class_code)
    class_student = class_students.build(org_class: org_class)
    class_student.save
  end
end
