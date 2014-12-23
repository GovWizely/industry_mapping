require 'spec_helper'

describe SearchController, type: :controller do
  fixtures :topics, :sectors, :industries, :sources
  render_views
  let(:topic) { topics(:german) }

  context "when endpoint is unknown" do
    before do
      get :lookup_by_topic, topic: 'unknown!', model: "industry", format: :json
    end
    it { should respond_with(:missing) }
  end

  describe "industries endpoint" do
    context 'when only topic param is present' do
      context 'and is right name' do
        before do
          get :lookup_by_topic, topic: topic.name, model: "industries", format: :json
        end

        it { should respond_with(:success) }

        it 'should have correct JSON in response' do
          json_response = JSON.parse(response.body)
          expect( json_response[0]['id']).to eq( topic.sector.industry.id)
          expect( json_response[0]['name']).to eq( topic.sector.industry.name)
        end
      end

      context 'and wrong name' do
        before do
          get :lookup_by_topic, topic: 'unknown!', model: "industries", format: :json
        end

        it { should respond_with(:success) }

        it 'returns empty JSON array in response' do
          json_response = JSON.parse(response.body)
          expect( json_response.length ).to eq 0
        end
      end
      it "does not change Topic number" do
        expect { 
          get :lookup_by_topic, topic: topic.name, model: "industries", format: :json
        }.to_not change{ Topic.count }
        
        expect { 
          get :lookup_by_topic, topic: 'unknown!', model: "industries", format: :json
        }.to_not change{ Topic.count }
      end
    end

    context 'when topic param and source are present' do
      context 'and are right named' do
        before do
          get :lookup_by_topic, topic: topic.name, source: topic.source.name, model: "industries", format: :json
        end

        it { should respond_with(:success) }

        it 'should have correct JSON in response' do
          json_response = JSON.parse(response.body)
          expect( json_response[0]['id']).to eq( topic.sector.industry.id)
          expect( json_response[0]['name']).to eq( topic.sector.industry.name)
        end
      end

      context 'and the topic is unknown' do
        let(:param) { {topic: 'unknown!', source: topic.source.name, model: "industries", format: :json} }
        
        it "response with success" do
          get :lookup_by_topic, param
          expect(response).to have_http_status(:success)
        end

        it 'returns empty JSON array in response' do
          get :lookup_by_topic, param
          json_response = JSON.parse(response.body)
          expect( json_response.length ).to eq 0
        end

        it "changes Topic number once" do
          expect { 
            get :lookup_by_topic, param
          }.to change{ Topic.count }.by(1)

          expect { 
            get :lookup_by_topic, param
          }.to change{ Topic.count }.by(0)

          get :lookup_by_topic, param
          json_response = JSON.parse(response.body)
          expect( json_response.length ).to eq 0
        end
      end

      context 'and the source is unknown but topic is correct' do
        let(:param) { {topic: topic.name, source: 'unknown!', model: "industries", format: :json} }
        
        it "response with success" do
          get :lookup_by_topic, param
          expect(response).to have_http_status(:success)
        end

        it 'returns empty JSON array in response' do
          get :lookup_by_topic, param
          json_response = JSON.parse(response.body)
          expect( json_response.length ).to eq 0
        end

        it "does not change Topic number" do
          expect { 
            get :lookup_by_topic, param
          }.to_not change{ Topic.count }
        end
      end
    end
  end
end
