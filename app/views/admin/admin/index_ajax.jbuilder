json.array! @channel_users do |user|
  json.id user.id
  json.name user.name
  json.address user.address
  json.created_at user.created_at.strftime('%Y-%m-%d')
  json.channel_size user.channel_schools.where(passed: true).size

  studentscount=[]

  user.channel_schools.where(passed: true).each do |school|
    studentscount << school.school.user_count
  end

  json.channel_reg studentscount.sum

  vipcount=[]
  user.channel_schools.where(passed: true).each do |s|
    vipcount << s.school.vip_count
  end

  json.channel_vip vipcount.sum
  if user.company
    json.company '公司'
  else
    json.company '个人'
  end
end