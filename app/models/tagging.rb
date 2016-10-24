class Tagging < ActiveRecord::Base
  belongs_to :dynamic
  belongs_to :tag, counter_cache: "tag_heat" #标签热度
end
