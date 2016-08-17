class Dynamic < ActiveRecord::Base
  belongs_to :user
  has_many   :taggings
  has_many   :tag, through: :taggings
  has_many   :attachments
  # has_many   :ref_dynamics, foreign_key: 'root_id', class_name: 'Dynamic'
  # belongs_to :root,         class_name: 'Dynamic'


  def addTag tag_name
    tag = Tag.find_by_name(tag_name)
    if tag.nil?
      tag = Tag.create(:name => tag_name)
      self.tags << tag
    else
      self.tags << tag
    end
  end
end