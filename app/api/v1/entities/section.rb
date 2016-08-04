module Entities
  class Section < Grape::Entity
    expose :id, :title, :author,:content
  end
end
