class View < ActiveRecord::Base
  belongs_to :viewer, class_name: 'User'
  belongs_to :view_record, class_name: 'Record'
end
