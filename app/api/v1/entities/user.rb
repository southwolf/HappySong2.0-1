module Entities
  class User < Grape::Entity
    expose :id, :uid, :phone, :name, :avatar ,:sex, :age, :desc, :vip, :is_first, :code, :auth_token
    expose :role, using: ::Entities::Role
    expose (:school_full_name) do |object, options|
      school   = object.grade_team_classes.first.try(:school)
      district = school.try(:district)
      city     = district.try(:city)

      "#{city}#{district}#{school}"
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
    expose :id, :uid, :phone, :name, :avatar ,:sex, :age, :desc
    expose (:followers_count)  { |user| user.followers.size }
    expose (:followings_count) { |user| user.followings.size }
    expose (:classmates_count) { |user| user.classmates.size - 1}
  end


  class Hashuser < Grape::Entity
      # expose (:time) {|key, value| key}
      # expose :user, using: ::Entities::Simpleuser do |key, value|
      #   value
      # end
      # expose (:users)  do |key, value|
      #   expose :user, value, using: ::Entities::Simpleuser
      # end
  end
end
