module Entities
  class Record < Grape::Entity
    expose :id, :felling, :is_public, :type, :created_at
    expose (:file_url) {|result| "http://localhost.com/#{file_url}" }
    expose :user,    using: Entities::User
    expose :article, using: Entities::Article
    expose :music,   using: Entities::Music
    expose :created_at
  end
end
