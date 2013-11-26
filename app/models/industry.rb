class Industry < ActiveRecord::Base
  has_many :sectors, :dependent => :destroy
end
