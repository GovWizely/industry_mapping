class Sector < ActiveRecord::Base
  belongs_to :industry
  has_many :emenus, :dependent => :destroy
end
