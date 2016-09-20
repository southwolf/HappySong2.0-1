module Entities
  class Article < Grape::Entity
    expose :id, :title, :author,  :records_count,:has_demo,:is_hot, :created_at
    expose (:content) {|object| object.content}
    expose :subject,       using: Entities::SimpleSubject
    expose :edition,       using: Entities::Edition
    expose :article_grade, using: Entities::ArticleGrape
    expose :unit,          using: Entities::Unit
    expose :records,       using: Entities::SimpleRecord
    expose :records_count
    expose :created_at
    expose (:cover_img) {|object| ENV['QINIUPREFIX']+object.cover_img }
    expose (:share_url) {|object| ENV['SHARERECORD']+"/share_article/#{object.id}"}
    # expose (:width) do |object|
    #   uri = URI(ENV['QINIUPREFIX']+object.cover_img+'?imageInfo')
    #   res = ::Net::HTTP.get_response(uri)
    #   info = ::ActiveSupport::JSON.decode res.body
    #   info["width"]
    # end

    # expose (:height) do |object|
    #   uri = URI(ENV['QINIUPREFIX']+object.cover_img+'?imageInfo')
    #   res = ::Net::HTTP.get_response(uri)
    #   info = ::ActiveSupport::JSON.decode res.body
    #   info["height"]
    # end
  end
end
