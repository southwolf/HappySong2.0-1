class Student::ProfileSerializer < ProfileSerializer
  attributes :followers_count, :followings_count
  attributes :vip
  attributes :count

  def count
    count = -1
    # object.org_classes.eager_load(:students).each do |o_c|
    object.org_classes.each do |o_c|
      count += o_c.students.count
    end
    count
  end

  def vip
    true
  end

  def followers_count
    object.followers.count
  end

  def followings_count
    object.followings.count
  end
end
