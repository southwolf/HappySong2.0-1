class StudentSerializer < ActiveModel::Serializer
  attributes :name, :uid, :avatar, :desc, :id

  def avatar
    ENV['QINIUPREFIX'] + object.avatar
  end
end
