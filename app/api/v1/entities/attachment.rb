module Entities
  class Attachment < Grape::Entity
    expose :id, :is_video, :created_at
    expose (:file_url) { |object| ENV['QINIUPREFIX']+object.file_url }
  end
end
