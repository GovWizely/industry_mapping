require 'spec_helper'

describe Topic do
  it { is_expected.to belong_to(:sector) }
  it { is_expected.to belong_to(:source) }
  it { is_expected.to have_one(:industry).through(:sector) }

  it { is_expected.to validate_presence_of(:source) }
  it { is_expected.to validate_presence_of(:name) }

  describe 'uniqueness validation' do
    let(:source1) { create(:source) }
    let(:source2) { create(:source) }
    let!(:topic) { create(:topic, name: 'Foo', source: source1) }

    it 'enforces uniqueness scoped to source' do
      expect(build(:topic, name: 'Bar', source: source1)).to be_valid
      expect(build(:topic, name: 'Foo', source: source2)).to be_valid
      expect(build(:topic, name: 'Foo', source: source1)).to_not be_valid
    end
  end
end
