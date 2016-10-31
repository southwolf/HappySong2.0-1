namespace :update do
  desc "热门更新"
  task update_hot: :environment do
    # 每周更新热门朗读
    time_range = (Time.now.beginning_of_week .. Time.now.end_of_week)
    records = Record..where(created_at: time_range).find_by_sql("SELECT a.* FROM records as a join views as b on a.id = b.view_record_id
                        WHERE (b.`created_at` BETWEEN '#{Time.now.beginning_of_week}' AND '#{Time.now.end_of_week}')
                        GROUP BY(a.id) ORDER BY count(b.num) DESC Limit 10")
    Record.where(:is_hot => true ).each do |record|
      record.update(:is_hot => false)
    end
    records.each do |record|
        record.update(:is_hot => true)
      end
  end

end
