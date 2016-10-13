class School < ActiveRecord::Base
  belongs_to :district
  belongs_to :user
  has_and_belongs_to_many :grades, :join_table => :grade_join_schools
  has_and_belongs_to_many :team_classes
  has_many :grade_team_classes

  has_many :channel_schools
  has_many :channel_users, :through => :channel_schools

  def students
    students = []
    grade_team_classes.each do |grade_team_class|
      students += grade_team_class.students
    end
    return students
  end

  def vip_count
    count = 0
    self.try(:grade_team_classes).each do |grade_team_class|
      grade_team_class.try(:students).each do |student|
        if student.vip?
          count += 1
        end
      end
    end
    return count
  end

  def user_count
    count = 0
    self.try(:grade_team_classes).each do |grade_team_class|
      count += grade_team_class.try(:students).size
    end
    return count
  end

  def fullname
    "#{self.try(:district).try(:name)} #{self.name}"
  end

  def address
    "#{self.try(:district).try(:city).try(:name)}#{self.try(:district).try(:name)}"
  end
end
