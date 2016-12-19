class Student::ProfileSerializer < ProfileSerializer
  attributes :followers_count, :followings_count
  attributes :vip

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
