class Teacher < User

  # associations
  has_many :classes, class_name: 'Org::Class', foreign_key: :teacher_id
  has_many :home_works, class_name: 'HomeWork', foreign_key: :teacher_id
  has_many :record_works, class_name: 'RecordWork', foreign_key: :teacher_id
  has_many :dynamic_works, class_name: 'DynamicWork', foreign_key: :teacher_id

  # instance methods
  def dismiss_class(class_name) # 解散班级
  end

end
