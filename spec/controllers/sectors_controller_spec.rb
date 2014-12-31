require 'spec_helper'

describe SectorsController, type: :controller do
  fixtures :emenus, :sectors, :industries
  render_views
  let(:emenu) { emenus(:german) }

  context 'when emenu lookup succeeds' do
    before do
      get :lookup, emenu: emenu.name, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'has correct JSON in response' do
      json_response = JSON.parse(response.body)
      expect(json_response['industry_id']).to eq(emenu.sector.industry.id)
      expect(json_response['industry_name']).to eq(emenu.sector.industry.name)
      expect(json_response['sector_id']).to eq(emenu.sector.id)
      expect(json_response['sector_name']).to eq(emenu.sector.name)
    end
  end

  context 'when emenu lookup fails' do
    before do
      get :lookup, emenu: 'unknown!', format: :json
    end

    it { is_expected.to respond_with(:missing) }

  end

end
