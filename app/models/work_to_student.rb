class WorkToStudent < ActiveRecord::Base
  belongs_to :student, class_name: "User"
  belongs_to :my_work, class_name: "Work"

end
