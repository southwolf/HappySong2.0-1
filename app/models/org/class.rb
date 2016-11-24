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

  # instance methods
end


# grade -> 年级 （enum）
# team_class -> 班级（enum）
# grade_team_class -> Org::Class 班级
# 