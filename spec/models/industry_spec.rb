require 'spec_helper'

describe Industry do
  it { is_expected.to have_many(:sectors) }
end
