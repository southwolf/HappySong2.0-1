class StudentSerializer < ActiveModel::Serializer
  attributes :name, :uid, :avatar

  def avatar
    ENV['QINIUPREFIX'] + object.avatar
  end
end