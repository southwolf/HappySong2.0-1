class Student < User

  # associations
  has_many :class_students, foreign_key: :student_id, class_name: 'ClassStudent'
  has_many :org_classes, through: :class_students # 学生可以加入多个班级

  has_many :student_works, foreign_key: :student_id, class_name: 'StudentWork'
  has_many :home_works, through: :student_works

  has_many :orders, foreign_key: :user_id, class_name: 'Order'
  has_one :associator, foreign_key: :student_id, class_name: 'Associator'

  has_many :do_works, foreign_key: :user_id, class_name: 'DoWork' # 少年说 | 创作作业 | 朗读作业 | 自由朗读
  has_many :do_dynamic_works, foreign_key: :user_id, class_name: 'DoDynamicWork'
  has_many :do_record_works,  foreign_key: :user_id, class_name: 'DoRecordWork'

  # instance methods
  def join_class(org_class) # 加入班级
    class_student = class_students.build(org_class: org_class)
    begin
      class_student.save
    rescue
      return nil
    end
  end

  def quit_class(org_class) # 学生可以退出某个班级
    class_student = class_students.find_by(org_class: org_class)
    class_student.destroy if class_student
  end

  # 是否是VIP
  def vip?
    return false if self.member.nil?
    return true if school.free?
    if self.member.expire_time > Time.now.to_i
      self.update(:vip => true)
      return true
    else
      self.update(:vip => false )
      return false
    end
  end

  def current_class
    org_classes.first
  end
end
