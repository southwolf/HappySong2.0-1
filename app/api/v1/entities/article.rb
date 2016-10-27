module Entities

  class SimpleArticle < Grape::Entity
    expose :id, :title, :author,:has_demo,:is_hot
    expose (:content) {|object| object.content}
    expose (:cover_img) {|object| ENV['QINIUPREFIX']+object.cover_img }
  end

  class Article < Grape::Entity
    expose :id, :title, :author,:has_demo,:is_hot, :created_at
    expose (:content) {|object| object.content}
    expose :records_count do |object|
      object.public_records.size
    end
    expose :created_at
    expose (:cover_img) {|object| ENV['QINIUPREFIX']+object.cover_img }
    expose (:share_url) {|object| ENV['SHARERECORD']+"/share_article/#{object.id}"}
  end

  class FullArticle < Article
    expose :records, using: Entities::SimpleRecord do |object|
      object.public_records
    end
  end

end
