json.array! @channel_users do |user|
  json.id user.id
  json.name user.name
  json.address user.address
  json.created_at user.created_at.strftime('%Y-%m-%d')
  json.channel_size user.schools.size

  studentscount=[]

  user.schools.each do |school|
    studentscount << school.user_count
  end

  json.channel_reg studentscount.sum

  vipcount=[]
  user.schools.each do |s|
    vipcount << s.vip_count
  end

  json.channel_vip vipcount.sum
  if user.company
    json.company '公司'
  else
    json.company '个人'
  end
end