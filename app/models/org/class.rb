# teacher_id 班级创建者 id
class Org::Class < ApplicationRecord

  # enum
  enum grade: {
    '一年级': 1,
    '二年级': 2,
    '三年级': 3,
    '四年级': 4,
    '五年级': 5,
    '六年级': 6
  }

  enum class: {
    '一班': 1,
    '二班': 2,
    '三班': 3,
    '四班': 4,
    '五班': 5,
    '六班': 6,
    '七班': 7,
    '八班': 8,
    '九班': 9,
    '十班': 10,
    '十一班': 11,
    '十二班': 12,
    '十三班': 13,
    '十四班': 14,
    '十五班': 15,
    '十六班': 16,
    '十七班': 17,
    '十八班': 18,
    '十九班': 19,
    '二十班': 20
  }

  # associations
  belongs_to :school, foreign_key: :school_id, class_name: 'Org::School'
  belongs_to :teacher, foreign_key: :teacher_id, class_name: 'User'

  has_many :class_works, foreign_key: :class_id, class_name: 'ClassWork'
  has_many :works, through: :class_works

  has_many :class_students, foreign_key: :class_id, class_name: 'ClassStudent'
  has_many :students, through: :class_students

  # delegate
  delegate :nation_name, :nation_fullname, to: :school

  # callbacks
  before_create :ensure_code
  def ensure_code
    loop do
      self.code = ([*?a..?z]+[*?1..?9]).sample(4).join
      break if Org::Class.where(code: code).empty?
    end
  end

  #instance methods
  def add_student(student)
  end

  def add_parent(parent)
  end

  def full_title
  end

  def title_with_county

  end

  def title_with_school
    school.name + title
  end

  def title
    grade_name + class_name
  end

  # private
  def class_name
    Org::Class.classes.invert[class_no]
  end

  def grade_name
    Org::Class.grades.invert[grade_no]
  end
end
