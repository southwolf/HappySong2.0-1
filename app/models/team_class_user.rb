class TeamClassUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :team_class
end
