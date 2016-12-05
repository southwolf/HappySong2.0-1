class Teacher::ProfileSerializer < ProfileSerializer
  attributes :followers_count, :followings_count, :class_count

  def followers_count
    object.followers.count
  end

  def followings_count
    object.followings.count
  end

  def class_count
    object.classes.count
  end
end
