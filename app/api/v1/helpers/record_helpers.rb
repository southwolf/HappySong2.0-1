module V1
  module RecordHelpers
    extend Grape::API::Helpers
    def update_hot
      records = Record.find_by_sql("SELECT a.id, count(b.num) FROM records as a join views as b on a.id = b.view_record_id
                          WHERE (b.`created_at` BETWEEN '2016-08-08 23:59:59' AND '2016-08-15 00:00:00') GROUP BY(a.id) Limit 10")
      Result.all.each do |record|
        record.update(:is_hot => false)
      end
      time_range = (Time.now.end_of_day - 7.day) .. Time.now.midnight

      records.each do |record|
        Record.find(record.id).update(:is_hot => true)
      end
    end
  end
end
