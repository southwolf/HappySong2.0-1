class Article < ActiveRecord::Base
  has_and_belongs_to_many :cate_items
  belongs_to :edition #版本【人教版】
  belongs_to :subject #科目【语文/英语】
  belongs_to :article_grade #年级学期【一年级上学期】
  belongs_to :unit
  has_many   :records
  has_many   :public_records, ->(){ where(is_public: true)},class_name: "Record"
  has_many   :banners, as: :targetable
  # has_many   :reports, as: :reportable

  has_many   :work_to_articles
  has_many   :work, through: :work_to_articles
end
