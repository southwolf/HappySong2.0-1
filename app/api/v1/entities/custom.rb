module Entities
  class Custom < Grape::Entity
    expose :id, :name
    expose (:type) do |objcet|
      object.class.to_s
    end
  end

  class IdAndName < Grape::Entity
    expose :id, :name
  end
end
