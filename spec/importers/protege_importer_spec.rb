require 'spec_helper'

describe ProtegeImporter do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/protege_importer" }
  let(:resource) { "#{fixtures_dir}/test_data.zip" }
  let(:importer) { ProtegeImporter.new(resource) }

  describe '#import' do
    let(:entry_hash) { YAML.load_file("#{fixtures_dir}/results.yaml") }

    let(:old_industry) { build(:industry) }
    let(:old_sector) { build(:sector) }
    let(:updateable_industry) { build(:industry, name: entry_hash[0]["name"], protege_id: entry_hash[0]["protege_id"]) }
    let(:updateable_sector) { build(:sector, name: entry_hash[1]["name"], protege_id: entry_hash[1]["protege_id"], industry: updateable_industry) }

    before { importer.import }

    let(:industry) { Industry.all[0].attributes }
    let(:sector1) { Sector.all[0].attributes }

    it 'creates the correct number of Active Record Industries and Sectors' do
      expect(Industry.count).to eq(2)
      expect(Sector.count).to eq(5)
    end

    it 'create the correct names and protege_ids for an Industry' do
      expect(industry["name"]).to eq(entry_hash[0]["name"])
      expect(industry["protege_id"]).to eq(entry_hash[0]["protege_id"])
    end
      
    it 'creates the correct names and protege_ids for a Sector' do
      expect(sector1["name"]).to eq(entry_hash[1]["name"])
      expect(sector1["protege_id"]).to eq(entry_hash[1]["protege_id"])
    end

    it 'create the correct industry_id for a Sector' do
      expect(sector1["industry_id"]).to eq(industry["id"])
    end

  end
end
