module Entities
  class User < Grape::Entity
    expose :id, :uid, :phone, :code, :auth_token
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

    expose (:points) do |object|
      0
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
    expose :school_full_name, if: ->(object, options) { object.try(:role).try(:name) == "student"} do |object, options|
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
    expose :id, :uid,:phone, :name
    expose (:avatar) { |object| ENV['QINIUPREFIX']+object.avatar}
  end

  class MyProfile < Grape::Entity
    expose :id, :uid, :phone, :name, :sex, :age, :desc
    expose (:vip) { |object| object.vip?}
    # expose (:children), using: Entities::User, if: -> (parent, options){ parent.role.try(:name) == "parent"}

    # expose (:parent),   using: Entities::User, if: -> (child, options) { child.role.try(:name) == "student" }

    #背景图片
    expose (:bg_image) { |object| ENV['QINIUPREFIX']+object.bg_image_url }

    #积分
    expose (:points) do |object|
      0
    end
    #老师的年级班级
    # expose :grade_team_classes, if: ->(user, options) { user.role.name == "teacher"}, using: Entities::GradeTeamClass

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
    #会员到期时间
    expose :expire_time, if: ->(object, options){ object.member.present?} do |object|
      object.member.expire_time.to_i
    end

    expose (:share_url) {|object| ENV['SHARERECORD']+"/share_profile/#{object.id}"}
    #分享链接
    expose :invite_url do |object|
      "http://120.26.118.28/invites?code=#{object.code}"
    end

    expose(:avatar) { |user| ENV['QINIUPREFIX']+user.avatar}
    expose (:followers_count)  { |user| user.followers.size }
    expose (:followings_count) { |user| user.followings.size }
    #学生的同学数量
    expose :classmates_count, if: ->(user, options){user.role.name=="student"} { |user| user.classmates.size}
    # 老师的班级数量
    expose :grade_team_classes_count, if: ->(user, options){ user.role.name="teacher"} { |user| user.grade_team_classes.size}
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
      object.phone.splice(0..2)+"****"+object.phone.splice(-4..-1)
    end
    expose (:vip) { |object| object.vip?}
  end
end
