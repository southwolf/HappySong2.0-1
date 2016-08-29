module Entities
  class Album < Grape::Entity
    expose :id, :created_at
    expose (:file_url) { |object| ENV['QINIUPREFIX']+object.file_url}

    expose (:width) do |object|
      uri = URI(ENV['QINIUPREFIX']+object.file_url+'?imageInfo')
      res = ::Net::HTTP.get_response(uri)
      info = ::ActiveSupport::JSON.decode res.body
      info["width"]
    end
    expose (:height) do |object|
      uri = URI(ENV['QINIUPREFIX']+object.file_url+'?imageInfo')
      res = ::Net::HTTP.get_response(uri)
      info = ::ActiveSupport::JSON.decode res.body
      info["height"]
    end
  end
end
