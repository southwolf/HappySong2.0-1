require 'rails_helper'

RSpec.describe NewApi::V1::Students::WorksController, type: :request do

  before do
    @teacher = Teacher.create(phone: '17711111111', name: 'test_teacher')
    @student = Student.create(phone: '17711111112', name: 'test_student')
    @org_class = @teacher.classes.create(name: 'TestClass')
    ClassStudent.create(class_id: @org_class.id, student_id: @student.id)
  end

  describe "GET #index" do
    it "should response with status 201 when created" do
    end
  end
end
