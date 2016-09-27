class GradeTeamClass < ActiveRecord::Base
  belongs_to :grade
  belongs_to :team_class
  belongs_to :school
  belongs_to :teacher,  class_name: 'User'
  has_many   :students, class_name: 'User'

  validates  :teacher_id, :uniqueness => { :scope => [:grade_id,:team_class_id, :school_id]}
  before_create :set_code
  # 生成4位 code
  def set_code
    loop do
    self.code = ([*?a..?z]+[*?1..?9]).sample(4).join
    break if GradeTeamClass.where(code: code).empty?
    end
  end

  def vip_count
    count = 0
    self.try(:students).each do |student|
      if student.vip?
        count += 1
      end
    end
    return count
  end

  def user_count
    count = self.try(:students).size || 0
    return count
  end

end
