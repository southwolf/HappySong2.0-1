module Entities
  class Targetable < Grape::Entity
    expose :id
    expose :file_url, if: ->(object, option){ object.respond_to?(:file_url)} do |object|
      ENV['QINIUPREFIX']+object.file_url
    end
    expose :content, if: ->(object, option){ object.respond_to?(:content)} do |object|
      object.content
    end
  end
end
