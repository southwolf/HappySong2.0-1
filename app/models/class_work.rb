class ClassWork < ApplicationRecord

  # associations
  belongs_to :home_work, foreign_key: :work_id, class_name: 'HomeWork'
  belongs_to :org_class, foreign_key: :class_id, class_name: 'Org::Class'
end
