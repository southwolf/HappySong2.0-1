class OrgClass::ClassSerializer < ClassSerializer

  def title
    object.title_with_school
  end

  belongs_to :teacher, serializer: OrgClass::TeacherSerializer
end
