module Entities
  class Music < Grape::Entity
    expose :id
    expose :name
    expose :file_url
    expose :music_type, using: ::Entities::MusicType
  end

  class MusicType < Grape::Entity
    expose :id
    expose :name
  end
end
