# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
    provinces = Province.create([{ name: '河南'},{ name: '安徽' }])
    cities    = City.create([{ name: '合肥', province: province.last}])
    districts = District.create([{ name: '高新区', city: cities.first}])
    shools    = School.create([{ name: '稻花香小学', district: districts.first}])
    grades    = Grade.create([{name: '一年级'}, {name: '二年级'}])
    team_classes = TeamClass.create([{name: '一班'}, {name: '二班'}])
   
