class Student::ShowWorkSerializer < ActiveModel::Serializer
  attributes :id, :teacher_name, :teacher_avatar, :teacher_desc,  :content, :start_time, :end_time, :type, :state
  attributes :created_at
  attributes :type

  def state
    object.state
  end

  def teacher_avatar
    ENV['QINIUPREFIX'] + object.teacher_avatar
  end

  has_many :articles
  class ArticleSerializer < ActiveModel::Serializer
    attributes :cover_img, :title, :author
    def cover_img
      ENV['QINIUPREFIX'] + object.cover_img
    end
  end
end
