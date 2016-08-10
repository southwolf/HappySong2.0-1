class Like < ActiveRecord::Base
  belongs_to :likeable,  polymorphic: true
  belongs_to :like_user, class_name: 'User'
end
