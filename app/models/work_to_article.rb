class WorkToArticle < ActiveRecord::Base
  belongs_to :article
  belongs_to :work
end
