module Entities
  class Category < Grape::Entity
    expose :id, :name
  end

  class CategoryWithItem < Category
    expose :cate_items, using: Entities::CateItem
  end

  class CateItem < Grape::Entity
    expose :id, :name
  end

end
