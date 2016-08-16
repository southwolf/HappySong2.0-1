class Dynamic < ActiveRecord::Base
  belongs_to :user
  has_many   :taggings
  has_many   :tag, through: :taggings
  has_many   :attachments
  # has_many   :ref_dynamics, foreign_key: 'root_id', class_name: 'Dynamic'
  # belongs_to :root,         class_name: 'Dynamic'


  def addTag(tag)
    
  end
end
