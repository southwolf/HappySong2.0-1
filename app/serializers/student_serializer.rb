class StudentSerializer < ActiveModel::Serializer
  attributes :name, :uid, :avatar, :desc

  def avatar
    ENV['QINIUPREFIX'] + object.avatar
  end
end
