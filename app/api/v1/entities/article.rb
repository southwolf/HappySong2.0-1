module Entities
  class Article < Grape::Entity
    expose :id, :title, :author, :cover_img
    expose :subject,       using: Entities::Subject
    expose :edition,       using: Entities::Edition
    expose :article_grade, using: Entities::ArticleGrape
    expose :unit,          using: Entities::Unit
    expose :sections,      using: Entities::Section do |article, options|
      article.article_sections
    end
    expose :created_at
  end
end
