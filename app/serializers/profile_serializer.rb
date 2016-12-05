class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :name, :sex, :desc, :code, :uid, :phone
  attributes :avatar, :bg_image

  def avatar
    ENV['QINIUPREFIX'] + object.avatar
  end

  def bg_image
    ENV['QINIUPREFIX'] + object.bg_image_url
  end
end

# 名字
# 背景图
# 头像
# ID
# 性别
# 签名
# 关注 -> 都是人
# 学校
# 班级

  # attributes :id, :code, :uid, :phone, :auth_token, :name, :is_first, :age, :sex, :desc
  # attributes :ios_pay_url, :avatar, :bg_image, :role