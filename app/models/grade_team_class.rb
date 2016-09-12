class GradeTeamClass < ActiveRecord::Base
  belongs_to :grade
  belongs_to :team_class
  belongs_to :school
  belongs_to :teacher,  class_name: 'User'
  has_many   :students, class_name: 'User'
 
  before_create :set_code
  # 生成4位 code
  def set_code
    loop do
    self.code = ([*?a..?z]+[*?1..?9]).sample(4).join
    break if GradeTeamClass.where(code: code).empty?
    end
  end

end
