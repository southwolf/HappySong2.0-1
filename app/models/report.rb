class Report < ActiveRecord::Base
  belongs_to :reportable, polymorphic: true
  belongs_to :report_user, class_name: 'User', foreign_key: :user_id
end
