module Entities
  class Banner < Grape::Entity
    expose :id, :text, :target, :target_id
    expose (:cover_img) {|object| ENV['QINIUPREFIX']+object.cover_img}
    # expose (:width) do |object|
    #   uri = URI(ENV['QINIUPREFIX']+object.cover_img+'?imageInfo')
    #   res = ::Net::HTTP.get_response(uri)
    #   info = ::ActiveSupport::JSON.decode res.body
    #   info["width"]
    # end
    # expose (:height) do |object|
    #   uri = URI(ENV['QINIUPREFIX']+object.cover_img+'?imageInfo')
    #   res = ::Net::HTTP.get_response(uri)
    #   info = ::ActiveSupport::JSON.decode res.body
    #   info["height"]
    # end
  end
end
