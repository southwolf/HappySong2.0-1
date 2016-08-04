module Entities
  class Banner < Grape::Entity
    expose :id, :cover_img, :text
  end
end
