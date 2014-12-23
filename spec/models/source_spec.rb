require 'spec_helper'

describe Source, type: :model do
  it { is_expected.to have_many(:topics) }

  it "has unique name" do
    Source.create(name: "Blah")
    expect( Source.new(name: "Blah") ).to_not be_valid
  end
end
