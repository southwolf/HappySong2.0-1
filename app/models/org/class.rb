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

  # instance methods
end


# grade -> 年级 （enum）
# team_class -> 班级（enum）
# grade_team_class -> Org::Class 班级
#
