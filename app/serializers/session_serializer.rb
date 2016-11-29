class SessionSerializer < ActiveModel::Serializer
  attributes :id, :code, :uid, :phone, :auth_token, :name, :is_first, :age, :sex, :desc
  attributes :ios_pay_url, :vip, :avatar, :bg_image, :role

  has_one :share_url do
    ENV['SHARERECORD'] + "share_profile/#{object.id}"
  end

  has_one :invite_url do
    ENV['SHARERECORD']+"invites?code=#{object.code}"
  end

  has_one :points, if: -> { object.class.name == 'Parent'} do
    if object.try(:credit).nil?
      '0'
    else
      object.try(:credit).try(:point) - object.try(:credit).try(:point)
    end
  end

  has_one :grade_team_classes, if: -> { object.class.name == 'Student' } do
    grade_team_class = object.try(:grade_team_class)
    if grade_team_class.present?
      grade = grade_team_class.try(:grade).try(:name)
      team_class = grade_team_class.try(:team_class).try(:name)
    "#{grade}#{team_class}"
    else
     " "
    end
  end

  has_one :school_full_name do
    if object.class.name == 'Student' || "Teacher"
      school   = object.grade_team_classes.first.try(:school)
      district = school.try(:district)
      city     = district.try(:city)
      if school.present? && district.present? && city.present?
        "#{city.try(:name)}#{district.try(:name)}#{school.try(:name)}"
      else
        ""
      end
    end
  end

  def ios_pay_url
    if object.class.name == 'Student'
      "http://abc.happysong.com.cn/web_pay/pay"
    else
      "http://abc.happysong.com.cn/web_pay/other_pay"
    end
  end

  def role
    object.class.name.downcase
  end

  def vip
    object.vip?
  end

  def avatar
    ENV['QINIUPREFIX'] + object.avatar
  end

  def bg_image
    ENV['QINIUPREFIX'] + object.bg_image_url
  end

  def name
    object.try(:name) || ""
  end
  def age
    object.try(:age) || ""
  end
  def desc
    object.try(:desc) || ""
  end

  def sex
    object.try(:sex) || ""
  end

end
