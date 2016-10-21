module Entities
  class Targetable < Grape::Entity
    expose :id
    expose :type do |object|
      object.class.to_s
    end
    expose :user, if: ->(object, option){ object.respond_to?(:user)}, using: ::Entities::User do |object|
      object.user
    end
    expose :file_url, if: ->(object, option){ object.respond_to?(:file_url)} do |object|
      ENV['QINIUPREFIX']+object.file_url
    end
    expose :content, if: ->(object, option){ object.respond_to?(:content)} do |object|
      object.content
    end
    expose :attachments, if: ->(object, option){ object.respond_to?(:attachments)},using: ::Entities::Attachment do |object|
      object.attachments
    end
    expose :article, if: ->(object, option) { object.respond_to?(:article)}, using: ::Entities::Article do |object|
      object.article
    end
    expose :top_comment_id, if: ->(object, option) { object.respond_to?(:top_comment_id)} do |object|
      object.top_comment_id
    end
    expose :style, if: ->(object, option) { object.respond_to?(:style)} do |object|
      object.style
    end
  end
end
