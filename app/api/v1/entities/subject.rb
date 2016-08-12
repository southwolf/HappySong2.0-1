module Entities
  class Subject < Grape::Entity
    expose :id, :name
    expose :grades, using: Entities::ArticleGrape do |subject, options|
      options[:grades]
    end
    expose :editions, using: Entities::Edition do |subject, options|
      options[:editions]
    end
  end
  class SimpleSubject < Grape::Entity
    expose :id, :name
  end
end
