class OrgClass::TeacherSerializer < ActiveModel::Serializer
  attributes :avatar, :name, :id

  def avatar
    ENV['QINIUPREFIX'] + object.avatar
  end
end
