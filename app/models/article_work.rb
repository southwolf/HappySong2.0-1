class ArticleWork < ApplicationRecord
  # associations
  belongs_to :article
  belongs_to :work, class_name: 'HomeWork', foreign_key: :work_id

end
