class Article < ActiveRecord::Base
  has_and_belongs_to_many :cate_items
  belongs_to :edition #版本【人教版】
  belongs_to :subject #科目【语文/英语】
  belongs_to :article_grade #年级学期【一年级上学期】
  belongs_to :unit
  has_many   :records

  has_many   :banners, as: :targetable
  # has_many   :reports, as: :reportable
end
