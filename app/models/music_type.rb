class MusicType < ActiveRecord::Base
  validates :name, presence: true
  has_many :musics
end
