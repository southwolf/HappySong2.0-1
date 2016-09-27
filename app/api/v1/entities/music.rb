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
  
  end

  class MusicType < Grape::Entity
    expose :id, :name
  end

  class MusicWithType < Music
    expose :music_type, using: Entities::MusicType
  end
end
