module Entities
  class Banner < Grape::Entity
    expose :id, :text, :targetable_type, :targetable_id, :link_url
    expose (:cover_img) {|object| ENV['QINIUPREFIX']+object.cover_img}
  end
end
