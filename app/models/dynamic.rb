class Dynamic < ActiveRecord::Base
  belongs_to :user
  has_many   :taggings
  has_many   :tag, through: :taggings
  has_many   :attachments
end
