class Source < ActiveRecord::Base
  has_many :mapped_terms, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end
