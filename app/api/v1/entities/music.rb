module Entities
  class Music < Grape::Entity
    expose :id, :name
    expose (:file_url) { |object| ENV['QINIUPREFIX']+ object.file_url}
    expose :music_type, using: ::Entities::MusicType
  end

  class MusicType < Grape::Entity
    expose :id, :name
  end
end
