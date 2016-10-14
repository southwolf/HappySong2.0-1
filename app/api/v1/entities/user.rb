module Entities
  class User < Grape::Entity
    expose :id, :uid, :phone, :code, :auth_token, :is_first
    # expose (:vip) {|object| object.vip? }
    expose (:avatar) { |object| ENV['QINIUPREFIX']+object.avatar}
    expose (:vip) { |object| object.vip?}
    expose (:bg_image) { |object| ENV['QINIUPREFIX']+object.bg_image_url}
    expose(:name) do |object|
      object.try(:name) || ""
    end
    expose(:age) do |object|
      object.try(:age) || ""
    end
    expose(:desc) do |object|
      object.try(:desc) || ""
    end

    expose(:sex) do |object|
    object.try(:sex) || ""
    end
    expose :role, using: ::Entities::Role

    expose :points, if: ->(user,options){ user.try(:role).try(:name) =="parent"} do |object|
      if object.try(:credit).nil?
        "0"
      else
        object.try(:credit).try(:point) - object.try(:credit).try(:point)
      end
    end
    #学生的班级
    expose :grade_team_classes, if: ->(user,options){ user.try(:role).try(:name) =="student"} do |user|
      grade_team_class = user.try(:grade_team_class)
      if grade_team_class.present?
        grade = grade_team_class.try(:grade).try(:name)
        team_class = grade_team_class.try(:team_class).try(:name)
      "#{grade}#{team_class}"
      else
       " "
      end
    end
    #教师的学校全名
    expose :school_full_name, if: ->(object, options){ object.try(:role).try(:name) =="teacher" } do |object, options|
      school   = object.grade_team_classes.first.try(:school)
      district = school.try(:district)
      city     = district.try(:city)
      if school.present? && district.present? && city.present?
        "#{city.try(:name)}#{district.try(:name)}#{school.try(:name)}"
      else
        ""
      end
    end

    # expose :grade_team_classes, if: ->(user, options) { user.role.name == "teacher"}, using: Entities::GradeTeamClass
    #学生的学校全名
    expose :school_full_name, if: ->(object, options){ object.try(:role).try(:name) == "student"} do |object, options|
      school = object.grade_team_class.try(:school)
      district = school.try(:district)
      city = district.try(:city)

      if school.present? && district.present? && city.present?
        "#{city.try(:name)}#{district.try(:name)}#{school.try(:name)}"
      else
        " "
      end
    end

    expose (:share_url) {|object| ENV['SHARERECORD']+"share_profile/#{object.id}"}

    expose :invite_url do |object|
      "http://120.26.118.28/invites?code=#{object.code}"
    end
  end

  class SimpleUser < Grape::Entity
    expose :id, :uid,:phone, :name,:is_first
    expose :role, using: ::Entities::Role
    expose (:avatar) { |object| ENV['QINIUPREFIX']+object.avatar}

    expose :school_full_name, if: ->(object, options){ object.try(:role).try(:name) =="teacher" } do |object, options|
      school   = object.grade_team_classes.first.try(:school)
      district = school.try(:district)
      city     = district.try(:city)

      if school.present? && district.present? && city.present?
        "#{city.try(:name)}#{district.try(:name)}#{school.try(:name)}"
      else
        ""
      end
    end

    # expose :grade_team_classes, if: ->(user, options) { user.role.name == "teacher"}, using: Entities::GradeTeamClass
    #学生的学校全名
    expose :school_full_name, if: ->(object, options){ object.try(:role).try(:name) == "student"} do |object, options|
      school = object.grade_team_class.try(:school)
      district = school.try(:district)
      city = district.try(:city)

      if school.present? && district.present? && city.present?
        "#{city.try(:name)}#{district.try(:name)}#{school.try(:name)}"
      else
        " "
      end
    end
  end

  class MyProfile < Grape::Entity
    expose :id, :uid, :phone,:desc,:is_first,:auth_token
    expose(:name) do |object|
      object.try(:name) || ""
    end
    expose(:age) do |object|
      object.try(:age) || ""
    end
    expose(:desc) do |object|
      object.try(:desc) || ""
    end
    expose(:sex) do |object|
      object.try(:sex) || ""
    end

    expose (:vip) { |object| object.vip?}

    #背景图片
    expose (:bg_image) { |object| ENV['QINIUPREFIX']+object.bg_image_url }

    #积分
    expose (:points) do |object|
      0
    end
    # 学生的年级班级
    expose :grade_team_classes, if: ->(user, options) {user.try(:role).try(:name) =="student"}do |user|
      grade_team_class = user.try(:grade_team_class)
      if grade_team_class.present?
        grade = grade_team_class.try(:grade).try(:name)
        team_class = grade_team_class.try(:team_class).try(:name)
      "#{grade}#{team_class}"
      else
       " "
      end
    end

    #教师的学校全名
    expose :school_full_name, if: ->(object, options){ object.try(:role).try(:name) =="teacher" } do |object, options|
      school   = object.grade_team_classes.first.try(:school)
      district = school.try(:district)
      city     = district.try(:city)

      if school.present? && district.present? && city.present?
        "#{city.try(:name)}#{district.try(:name)}#{school.try(:name)}"
      else
        ""
      end
    end


    expose :school_full_name, if: ->(object, options){ object.try(:role).try(:name) == "student"} do |object, options|
      school = object.grade_team_class.try(:school)
      district = school.try(:district)
      city = district.try(:city)

      if school.present? && district.present? && city.present?
        "#{city.try(:name)}#{district.try(:name)}#{school.try(:name)}"
      else
        " "
      end
    end

    expose :can_inviter, if: ->(object, options){ object.try(:role).try(:name) =="teacher" } do |object, options|
      object.can_inviter?
    end
    #会员到期时间
    expose :expire_time, if: ->(object, options){ object.member.present?} do |object|
      object.member.expire_time.to_i
    end

    expose (:share_url) {|object| ENV['SHARERECORD']+"/share_profile/#{object.id}"}
    #分享链接
    expose :invite_url do |object|
       ENV['SHARERECORD']+"invites?code=#{object.code}"
    end

    expose(:avatar) { |user| ENV['QINIUPREFIX']+user.avatar}
    expose (:followers_count)  { |user| user.followers.size }
    expose (:followings_count) { |user| user.followings.size }
    #学生的同学数量
    expose :classmates_count, if: ->(user, options){user.role.name=="student"} do |user|
      if user.classmates.nil?
        "0"
      else
        user.classmates.size
      end
    end
    # 老师的班级数量
    expose :grade_team_classes_count, if: ->(user, options){ user.role.name="teacher"} { |user| user.grade_team_classes.size}
  end

  class MyProfileAddRole < MyProfile
    expose :role, using: ::Entities::Role
  end
  class HashUser < Grape::Entity
    expose (:time) { |object| object[0]}
    expose (:size) { |object| object[1].size}
    expose :users, using: Entities::User do |object|
      object[1]
    end
  end

  #student
  class InviteUser < Grape::Entity
    expose (:phone) do |object|
      object.phone.to_s.slice(0..2)+"****"+object.phone.to_s.slice(-4..-1)
    end
    # expose (:vip) { |object| object.vip?}
  end
end
