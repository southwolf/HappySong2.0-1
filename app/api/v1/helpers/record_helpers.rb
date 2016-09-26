module V1
  require 'active_support'
  module RecordHelpers
    extend Grape::API::Helpers
    def update_hot
      if Time.now.day = Time.now.end_of_week
        records = Record.find_by_sql("SELECT a.id, count(b.num) FROM records as a join views as b on a.id = b.view_record_id
                            WHERE (b.`created_at` BETWEEN '#{Time.now.end_of_day - 7.day}' AND '#{Time.now.end_of_day}') GROUP BY(a.id) Limit 10")
        Record.all.each do |record|
          record.update(:is_hot => false)
        end
      # time_range = (Time.now.end_of_day - 7.day) .. Time.now.midnight
        records.each do |record|
          Record.find(record.id).update(:is_hot => true)
        end
      end
    end
  end
end
