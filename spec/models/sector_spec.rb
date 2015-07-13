require 'spec_helper'

describe Sector do
  it { is_expected.to belong_to(:industry) }
  it { is_expected.to have_many(:topics) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:protege_id) }

  describe 'uniqueness validation' do
    let(:industry1) { create(:industry) }
    let(:industry2) { create(:industry) }
    let!(:sector) { create(:sector, name: 'Foo', industry: industry1, protege_id: 1) }

    it 'enforces uniqueness scoped to source' do
      expect(build(:sector, name: 'Bar', industry: industry1, protege_id: 2)).to be_valid
      expect(build(:sector, name: 'Foo', industry: industry1, protege_id: 3)).to_not be_valid
      expect(build(:sector, name: 'Foo2', industry: industry1, protege_id: 1)).to_not be_valid

      expect(build(:sector, name: 'Foo', industry: industry2)).to be_valid
    end
  end
end
