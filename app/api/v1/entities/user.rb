module Entities
  class User < Grape::Entity
    expose :id, :uid, :phone, :vip, :is_first, :code, :auth_token
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
    expose(:avatar) { |user| ENV['QINIUPREFIX']+user.avatar}
    expose (:followers_count)  { |user| user.followers.size }
    expose (:followings_count) { |user| user.followings.size }
    expose (:classmates_count) { |user| user.classmates.size}
  end
end
