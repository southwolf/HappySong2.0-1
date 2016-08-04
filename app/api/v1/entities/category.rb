module Entities
  class Category < Grape::Entity
    expose :id, :name
    expose :cate_items, using: ::Entities::CateItem do |cate|
      cate.cate_items
    end
  end
end
