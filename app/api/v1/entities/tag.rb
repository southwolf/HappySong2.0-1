module Entities
  class Tag < Grape::Entity
    expose :id, :name
    expose (:cover_img) do |object|
      ENV['QINIUPREFIX']+ object.cover_img
    end
  end
  class ShowTag < Tag
    unexpose :cover_img
  end
end
