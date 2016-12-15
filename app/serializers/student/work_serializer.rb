class Student::WorkSerializer < ActiveModel::Serializer
  attributes :avatar, :title, :teacher_name, :content, :type, :end_time, :state
end
