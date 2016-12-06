class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :name, :sex, :desc, :code, :uid, :phone
  attributes :avatar, :bg_image, :role

  def avatar
    ENV['QINIUPREFIX'] + object.avatar
  end

  def bg_image
    ENV['QINIUPREFIX'] + object.bg_image_url
  end

  def role
    { 
      name: object.class.name.downcase 
    }
  end
end