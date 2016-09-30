module Entities
  class Banner < Grape::Entity
    expose :id, :text, :targetable_type, :targetable_id
    expose (:link_url) do |object|
      if object.link_url.nil?
        ""
      else
        object.link_url
      end
    end
    expose (:cover_img) {|object| ENV['QINIUPREFIX']+object.cover_img}
  end
end
