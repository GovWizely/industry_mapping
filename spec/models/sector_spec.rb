require 'spec_helper'

describe Sector do
  it { is_expected.to belong_to(:industry) }
  it { is_expected.to have_many(:topics) }
end
