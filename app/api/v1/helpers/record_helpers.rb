module V1
  module RecordHelpers
    extend Grape::API::Helpers
    def update_hot
    #   Record.all.each do |record|
    #     record.update(:is_hot => false)
    #   end
    #   time_range = (Time.now.end_of_day - 7.day) .. Time.now.midnight

    #   Record.where(:created_at => time_range).take(10).each do |record|
    #     record.update(:is_hot => true)
    #   end
    end
  end
end
