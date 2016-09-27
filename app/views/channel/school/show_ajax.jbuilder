students = []


if @type=='all' #全部
  viptmp = []
  GradeTeamClass.where(school_id: params[:school_id]).each do |grade_team_class|
    students += grade_team_class.students.where(created_at: (@tmptime.beginning_of_month..@tmptime.end_of_month))
  end

  GradeTeamClass.where(school_id: params[:school_id]).each do |grade_team_class|
    viptmp += grade_team_class.students.where(created_at: (@tmptime.beginning_of_month..@tmptime.end_of_month), vip: true)
  end
  vipcount=viptmp.count
end
if @type=='monthvip' #月费会员
  GradeTeamClass.where(school_id: params[:school_id]).each do |grade_team_class|
    students += grade_team_class.students.where(created_at: (@tmptime.beginning_of_month..@tmptime.end_of_month), vip: true)
    tmpstudent=[]
    students.each do |stu|
      if stu.member.member_type == 'month'
        tmpstudent << stu
      end
    end
    students=tmpstudent
  end
  vipcount=students.count
end
if @type=='yearvip' #年费会员
  GradeTeamClass.where(school_id: params[:school_id]).each do |grade_team_class|
    students += grade_team_class.students.where(created_at: (@tmptime.beginning_of_month..@tmptime.end_of_month), vip: true)
    puts students.count
    tmpstudent=[]
    students.each do |stu|
      if stu.member.member_type == 'years'
        tmpstudent << stu
      end
    end
    students=tmpstudent
    vipcount=students.count
  end
end




if params[:pageIndex]

  @re_students = Kaminari.paginate_array(students).page(params[:pageIndex]).per(12)

  json.array! @re_students do |student|
    json.id student.id
    json.name student.name
    json.phone student.phone.first(3)+'****'+student.phone.last(4)
    json.created_at student.created_at
    json.vip student.vip
    if student.vip
      json.type 'vip'
    else
      json.type 'reg'
    end
  end
else
  json.count students.count
  json.vipCount vipcount
end

