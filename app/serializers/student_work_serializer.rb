class StudentWorkSerializer < ActiveModel::Serializer
  attributes :id, :time, :name, :avatar, :desc
  def name
    object.student.name
  end

  def avatar
    ENV['QINIUPREFIX'] + object.student.avatar
  end

  def desc
    object.student.desc
  end

  def id
    object.student_id
  end
  def time
    object.updated_at
  end

end
