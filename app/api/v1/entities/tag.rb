module Entities
  class Tag < Grape::Entity
    expose :id, :name
    expose (:cover_img) { |object| ENV['QINIUPREFIX']+object.cover_img}
  end
end
