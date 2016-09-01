module Entities
  class User < Grape::Entity
    expose :id, :uid, :phone, :code, :auth_token
    expose (:vip) {|object| object.vip? }
    expose (:avatar) { |object| ENV['QINIUPREFIX']+object.avatar}
    expose(:name) do |object|
      if object.name.blank?
        ""
      else
        object.name
      end
    end
    expose(:age) do |object|
      if object.age.blank?
        ""
      else
        object.age
      end
    end
    expose(:desc) do |object|
      if object.desc.blank?
        ""
      else
        object.desc
      end
    end

    expose(:sex) do |object|
      if object.sex.blank?
        ""
      else
        object.sex
      end
    end
    expose :role, using: ::Entities::Role

    expose (:points) do |object|
      0
    end
    expose (:school_full_name) do |object, options|
      school   = object.grade_team_classes.first.try(:school)
      district = school.try(:district)
      city     = district.try(:city)

      if school.present? && district.present? && city.present?
        "#{city.try(:name)}#{district.try(:name)}#{school.try(:name)}"
      else
        ""
      end
    end
    expose :url
    def url
      "http://host/users/show/#{object.id}"
    end
  end

  class SimpleUser < Grape::Entity
    expose :id, :uid,:phone, :name
  end

  class MyProfile < Grape::Entity
    expose :id, :uid, :phone, :name, :sex, :age, :desc
    expose (:vip) { |object| object.vip?}
    expose (:children), using: Entities::MyProfile, if: -> (parent, options){ parent.role.try(:name) == "parent"}

    expose (:parent),   using: Entities::MyProfile, if: -> (child, options) { child.role.try(:name) == "student" }

    expose :expire_time, if: ->(object, options){ object.member.present?} do |object|
      object.member.expire_time
    end

    expose(:avatar) { |user| ENV['QINIUPREFIX']+user.avatar}
    expose (:followers_count)  { |user| user.followers.size }
    expose (:followings_count) { |user| user.followings.size }
    expose (:classmates_count) { |user| user.classmates.size}
  end
  class HashUser < Grape::Entity
    expose (:time) { |object| object[0]}
    expose (:size) { |object| object[1].size}
    expose :users, using: Entities::User do |object|
      object[1]
    end
  end
end
