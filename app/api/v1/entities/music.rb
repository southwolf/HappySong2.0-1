module Entities
  class Music < Grape::Entity
    expose :id, :name
    expose (:author) do |object|
      if object.author.blank?
        ""
      else
        object.author
      end
    end
    expose (:file_url) { |object| ENV['QINIUPREFIX']+ object.file_url}
    expose (:cover_img){ |object| ENV['QINIUPREFIX']+ object.cover_img}
    
    expose (:width) do |object|
      uri = URI(ENV['QINIUPREFIX']+object.cover_img+'?imageInfo')
      res = ::Net::HTTP.get_response(uri)
      info = ::ActiveSupport::JSON.decode res.body
      info["width"]
    end

    expose (:height) do |object|
      uri = URI(ENV['QINIUPREFIX']+object.cover_img+'?imageInfo')
      res = ::Net::HTTP.get_response(uri)
      info = ::ActiveSupport::JSON.decode res.body
      info["width"]
    end
  end

  class MusicType < Grape::Entity
    expose :id, :name
  end

  class MusicWithType < Music
    expose :music_type, using: Entities::MusicType
  end
end
