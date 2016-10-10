module Entities

  class SimpleArticle < Grape::Entity
    expose :id, :title, :author
    expose (:content) {|object| object.content}
    expose (:cover_img) {|object| ENV['QINIUPREFIX']+object.cover_img }
  end

  class Article < Grape::Entity
    expose :id, :title, :author,  :records_count,:has_demo,:is_hot, :created_at
    expose (:content) {|object| object.content}
    expose :records_count
    expose :created_at
    expose (:cover_img) {|object| ENV['QINIUPREFIX']+object.cover_img }
    expose (:share_url) {|object| ENV['SHARERECORD']+"/share_article/#{object.id}"}
  end

  class FullArticle < Article
    expose :records, using: Entities::SimpleRecord
  end

end
