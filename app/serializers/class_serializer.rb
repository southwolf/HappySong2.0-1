class ClassSerializer < ActiveModel::Serializer
  attributes :id, :code

  has_one :class_name do
    object.title
  end
end
