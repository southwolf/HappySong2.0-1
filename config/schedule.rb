every  1.day, :at => '4:30 am' do
  runner "cd /apps/love_to_read_version2/current && rake RAILS_ENV='production' cash_back:task"
  runner "cd /apps/love_to_read_version2/current && rake RAILS_ENV='production' update:update_hot"
end
