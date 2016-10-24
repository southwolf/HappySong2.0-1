module V1
  require 'active_support'
  module RecordHelpers
    extend Grape::API::Helpers
    def update_hot
      if Date.today == Date.today.end_of_week
        records = Record.find_by_sql("SELECT a.* FROM records as a join views as b on a.id = b.view_record_id
                            WHERE (b.`created_at` BETWEEN '#{Time.now.beginning_of_week}' AND '#{Time.now.end_of_week}')
                            GROUP BY(a.id) ORDER BY count(b.num) DESC Limit 10")
        Record.where(:is_hot => true ).each do |record|
          record.update(:is_hot => false)
        end
      # time_range = (Time.now.end_of_day - 7.day) .. Time.now.midnight
        records.each do |record|
          record.update(:is_hot => true)
        end
      end
    end
  end
end
