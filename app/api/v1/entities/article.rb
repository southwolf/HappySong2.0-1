module Entities
  class Article < Grape::Entity
    expose :id, :title, :author, :records_count,:is_demo, :created_at
    expose :subject,       using: Entities::SimpleSubject
    expose :edition,       using: Entities::Edition
    expose :article_grade, using: Entities::ArticleGrape
    expose :unit,          using: Entities::Unit
    expose :records_count
    expose :created_at
    expose (:cover_img) {|object| ENV['QINIUPREFIX']+object.cover_img } 
  end
end
