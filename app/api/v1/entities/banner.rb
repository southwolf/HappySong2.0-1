module Entities
  class Banner < Grape::Entity
    expose :id, :text
    expose :cover_img {| object| ENV['QINIUPREFIX']+object.cover_img}
  end
end
