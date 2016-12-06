class ClassSerializer < ActiveModel::Serializer
  attributes :id, :code, :title

  def title
    object.title 
  end
end
