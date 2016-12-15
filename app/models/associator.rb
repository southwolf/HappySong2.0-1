# 学生 -> 会员
class Associator < ApplicationRecord
  # associations
  belongs_to :student, class_name: 'Student', foreign_key: 'student_id'

  # methods
  def renew(type) # 续费会员
    case type
    when 'month'
      update_columns(type: 'MonthAssociator', expire_time: (self.end_date + 30) )
    when 'year'
      update_columns(type: 'YearAssociator', expire_time: (self.end_date + 365) )
    end
  end

  def vip?
    expire_time >= Date.today
  end

  protected
  def end_date
    Date.today > expire_time ? Date.today : expire_time
  end
end
