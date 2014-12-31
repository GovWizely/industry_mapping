require 'spec_helper'

describe Topic do
  it { is_expected.to belong_to(:sector) }
  it { is_expected.to belong_to(:source) }
  it { is_expected.to have_one(:industry).through(:sector) }

  describe 'validations' do
    let(:source) { Source.create( name: "Blah 2" ) }
    let(:source2) { Source.create( name: "Blah 3" ) }

    it "is valid if 'name-source' is not duplicated" do
      Topic.create(name: "Blah", source: source )
      expect( Topic.new(name: "Blah", source: source2 ) ).to be_valid
      expect( Topic.new(name: "Foo", source: source ) ).to be_valid
    end

    it "is not valid if 'name-source' is duplicated" do
      Topic.create(name: "Blah", source: source )
      expect( Topic.new(name: "Blah", source: source ) ).to_not be_valid
    end
  end
end
