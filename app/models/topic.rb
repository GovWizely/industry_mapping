class Topic < ActiveRecord::Base
  belongs_to :sector
  belongs_to :source
  has_one :industry, through: :sector

  validates :source, presence: true
  validates :name, uniqueness: { scope: :source_id }
end
