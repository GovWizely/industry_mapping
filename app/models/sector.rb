class Sector < ActiveRecord::Base
  belongs_to :industry
  has_many :topics, dependent: :destroy
  validates :name, presence: true, uniqueness: { scope: :industry }
  validates :protege_id, presence: true, uniqueness: { scope: :industry }
end
