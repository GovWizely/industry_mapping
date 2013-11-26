require 'spec_helper'

describe Sector do
  it { should belong_to :industry }
  it { should have_many :emenus }
end
