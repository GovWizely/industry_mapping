require 'spec_helper'

describe SectorsController, type: :controller do
  fixtures :emenus, :sectors, :industries
  render_views
  let(:emenu) { emenus(:german) }

  context 'when emenu lookup succeeds' do
    before do
      get :lookup, emenu: emenu.name, format: :json
    end

    it { should respond_with(:success) }

    it 'should have correct JSON in response' do
      json_response = JSON.parse(response.body)
      json_response['industry_id'].should == emenu.sector.industry.id
      json_response['industry_name'].should == emenu.sector.industry.name
      json_response['sector_id'].should == emenu.sector.id
      json_response['sector_name'].should == emenu.sector.name
    end
  end

  context 'when emenu lookup fails' do
    before do
      get :lookup, emenu: 'unknown!', format: :json
    end

    it { should respond_with(:missing) }

  end

end
