require 'spec_helper'

describe Industry do
  it { is_expected.to have_many(:sectors) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end
