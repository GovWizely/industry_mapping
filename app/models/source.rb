class Source < ActiveRecord::Base
  has_many :topics
  validates :name, uniqueness: true
end
