module Entities
  class Album < Grape::Entity
    expose :id, :created_at
    expose (:file_url) { |object| ENV['QINIUPREFIX']+object.file_url}
  end
end
