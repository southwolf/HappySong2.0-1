# 具体的某一个班级
class Org::Class < ApplicationRecord

  # enum
  enum grades: {
    '一年级': 1,
    '二年级': 2,
    '三年级': 3,
    '四年级': 4,
    '五年级': 5,
    '六年级': 6
  }

  enum classes: {
    '一班': 1,
    '二班': 2,
    '三班': 3,
    '四班': 4,
    '五班': 5,
    '六班': 6,
    '七班': 7,
    '八班': 8,
    '九班': 9,
    '十班': 10
  }

  # associations
  belongs_to :school, foreign_key: 'school_id', class_name: 'Org::School'

  # delegate
  delegate :nation_name, :nation_fullname, to: :school

  #instance methods

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

  private
  def class_name
    Org::Class.classes.invert[self.class_no]
  end

  def grade_name
    Org::Class.grades.invert[self.grade_no]
  end
end
