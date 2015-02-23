class Industry < ActiveRecord::Base
  has_many :sectors, :dependent => :destroy
  validates :name, presence: true, uniqueness: true
end
