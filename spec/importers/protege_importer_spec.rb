require 'spec_helper'

describe ProtegeImporter do
  describe '#import' do
    
    before(:all) do
      Sector.destroy_all
      Industry.destroy_all
      fixtures_dir = "#{Rails.root}/spec/fixtures/protege_importer" 
      resource = "#{fixtures_dir}/test_data.zip" 
      importer = ProtegeImporter.new(resource)
      @entry_hash = YAML.load_file("#{fixtures_dir}/results.yaml")

      deletable_industry = create(:industry)
      updateable_industry = create(:industry, name: @entry_hash[0]["name"], protege_id: @entry_hash[0]["protege_id"])
      updateable_sector = create(:sector, name: @entry_hash[1]["name"], protege_id: @entry_hash[1]["protege_id"], industry: updateable_industry)
      deletable_sector = create(:sector, industry: updateable_industry)

      importer.import
 
      @industry = Industry.all[0].attributes
      @sector1 = Sector.all[0].attributes
    end

    it 'creates the correct number of Active Record Industries and Sectors' do
      expect(Industry.count).to eq(2)
      expect(Sector.count).to eq(5)
    end

    it 'create the correct names and protege_ids for an Industry' do
      expect(@industry["name"]).to eq(@entry_hash[0]["name"])
      expect(@industry["protege_id"]).to eq(@entry_hash[0]["protege_id"])
    end
      
    it 'creates the correct names and protege_ids for a Sector' do
      expect(@sector1["name"]).to eq(@entry_hash[1]["name"])
      expect(@sector1["protege_id"]).to eq(@entry_hash[1]["protege_id"])
    end

    it 'create the correct industry_id for a Sector' do
      expect(@sector1["industry_id"]).to eq(@industry["id"])
    end

  end
end
