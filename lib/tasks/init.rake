CN_CODE = '100000'
BJ_CODE = '110000'
TJ_CODE = '120000'
SH_CODE = '310000'
CQ_CODE = '500000'

ZXS_ARY = [BJ_CODE, TJ_CODE, SH_CODE, CQ_CODE]
FADE_NAME = {
  高新区: "蜀山区",
  经开区: "蜀山区",
  新站区: "瑶海区"
}


namespace :init do

  desc "Test C"
  task :migrate_init => [:user_type, :migrate_school, :migrate_class] do
    puts 'Over'
  end

  desc "给学生生成会员信息"
  task generate_associator: :environment do
    puts '------> Start generate_associator'
    Student.find_each do |student|
      a = student.create_associator(
        start_time: Date.today,
        expire_time: Date.today + 30,
        type: 'MonthAssociator'
      )
    end

  end

  desc "迁移班级数据"
  task :migrate_class => :environment do
    puts '------> Start migrate class'
    GradeTeamClass.find_each do |gt_class|
      puts "---------> GradeTeamClass id: #{gt_class.id} "
      school_id = gt_class.school_id
      teacher_id = gt_class.teacher_id
      grade_no = gt_class.grade_id
      class_no = gt_class.team_class_id
      code = gt_class.code
      org_class = Org::Class.new(
        school_id: school_id,
        grade_no: grade_no,
        class_no: class_no,
        code: code,
        teacher_id: teacher_id
      )
      org_class.save
    end
  end

  desc "迁移学校数据"
  task migrate_school: :environment do
    puts '------> Start migrate school'
    School.find_each do |school|
      puts "---------> School id: #{school.id} "
      @district = District.find_by(id: school.district_id)
      district_name  = FADE_NAME[@district.name.to_sym].blank? ? @district.name : FADE_NAME[@district.name.to_sym]
      @nation = Nation.find_by(name: district_name)
      if @nation.blank?
        puts @district.city.name + ' ' + @district.name + ' ' + school.id.to_s
      end
      org_school = Org::School.new(id: school.id, name: school.name, nation: @nation)
      org_school.save
    end
  end

  desc "导入地区数据"
  task import_nations: :environment do
    puts '------> Start import_nations'
    CityCodesParser.new("lib/3rds/china_code.txt").parse
  end

  desc "初始化用户类型"
  task user_type: :environment do
    puts '------> Start migrate user type'
    User.find_each do |user|
      user.update_columns({type: user.role.try(:name).try(:capitalize)})
    end
  end
end

module Ext
  def is_under_zxs?(code)
    ZXS_ARY.include? code
  end
end

class CityCodesParser
  include Ext
  def initialize(file_path)
    @source_file = File.open(file_path)
    @areas = Array.new
  end

  def parse
    read_file
    write_to_database
  end

  private

  def read_file
    @source_file.each do |line|
      line_as_array = LineAsArray.new(line.split(' '))
      line_as_array.is_province? ? @areas << province_parse(line_as_array) : city_parse(line_as_array)
    end
  end

  def write_to_database
    @areas.each do |province|
      @nation = Nation.create(name: province[:name], code: province[:code], admin_code: CN_CODE, tag: 1, parent_id: nil)
      province[:cities].each do |city|
        if ZXS_ARY.include? city[:code]
          @city = Nation.create(name: city[:name], code: city[:code].to_i + 100, admin_code: @nation.code, tag: 2, parent_id: @nation.id)
        else
          @city = Nation.create(name: city[:name], code: city[:code], admin_code: @nation.code, tag: 2, parent_id: @nation.id)
        end
        city[:counties].each do |country|
          @country = Nation.create(name: country[:name], code: country[:code], admin_code: @city.code, tag: 3, parent_id: @city.id)
        end
      end
    end
  end

  def close_file
    @source_file.close
  end

  def province_parse(line_as_array)
    province = line_as_array.build_province
    province[:cities] << build_city(line_as_array.code, line_as_array) if is_under_zxs?(line_as_array.code.to_s)
    province
  end

  def city_parse(line_as_array)
    if province = find_province(line_as_array.parent_code) # 这里是能找到 省 一级 (找不到的自然就归为 区县 一级)
      is_under_zxs?(province[:code]) ? province[:cities].first[:counties] << line_as_array.build_country : province[:cities] << build_city(line_as_array.parent_code, line_as_array)
    else
      country_parse(line_as_array)
    end
  end

  def country_parse(line_as_array) # 需要找到对应的市 市信息存贮在省
    if province = find_province(trans_country_code_to_province_code(line_as_array.code))
      province[:cities].each do |c|
        c[:counties] << line_as_array.build_country if c[:code] == line_as_array.parent_code
      end
    end
  end

  def trans_country_code_to_province_code(code)
    code[0..1] + '0000'
  end

  def find_province(code)
    province = nil
    @areas.each do |prov|
      return province = prov if code == prov[:code]
    end
    province
  end

  def build_city(admin_code, line_as_array)
    {
      admin_code: admin_code,
      code: line_as_array.code,
      counties: [],
      name: line_as_array.name
    }
  end
end

class LineAsArray
  attr_accessor :code, :parent_code, :name

  def initialize(line)
    @code = line[0]
    @name = line[1]
    @parent_code = line[4]
  end

  def is_province?
    CN_CODE == parent_code
  end

  # def is_zxs?
  #   ZXS_ARY.include? code
  # end

  def build_province
    {
      code: code,
      cities: [],
      name: name
    }
  end

  def build_country
    {
      admin_code: parent_code,
      code: code,
      name: name
    }
  end

end
