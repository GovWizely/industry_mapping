require 'spec_helper'

describe Api::V1::IndustriesController, type: :controller do
  render_views

  let!(:topic) { create(:topic, name: 'German Cars') }

  context 'when endpoint is unknown' do
    before { get :index, topic: 'unknown!' }

    it { is_expected.to respond_with(:success) }

    it 'has no industries in response' do
      json_response = JSON.parse(response.body)
      expect(json_response.count).to eq(0)
    end
  end

  describe 'industries endpoint' do
    context 'when only topic param is present' do
      context 'and is right name' do
        before { get :index, topic: topic.name }

        it { is_expected.to respond_with(:success) }

        it 'has correct JSON in response' do
          json_response = JSON.parse(response.body)
          expect(json_response[0]['id']).to eq( topic.sector.industry.id)
          expect(json_response[0]['name']).to eq( topic.sector.industry.name)
        end
      end

      context 'and wrong name' do
        before { get :index, topic: 'unknown!' }

        it { is_expected.to respond_with(:success) }

        it 'returns empty JSON array in response' do
          json_response = JSON.parse(response.body)
          expect( json_response.length ).to eq 0
        end
      end
      it "does not change Topic number" do
        expect { get :index, topic: topic.name }.to_not change{ Topic.count }
        expect { get :index, topic: 'unknown!' }.to_not change{ Topic.count }
      end
    end

    context 'when topic param and source are present' do
      context 'and are right named' do
        before { get :index, topic: topic.name, source: topic.source.name }

        it { is_expected.to respond_with(:success) }

        it 'has correct JSON in response' do
          json_response = JSON.parse(response.body)
          expect( json_response[0]['id']).to eq( topic.sector.industry.id)
          expect( json_response[0]['name']).to eq( topic.sector.industry.name)
        end
      end

      context 'and the topic is unknown' do
        let(:param) { {topic: 'unknown!', source: topic.source.name} }

        it 'responds with success' do
          get :index, param
          expect(response).to have_http_status(:success)
        end

        it 'returns empty JSON array in response' do
          get :index, param
          json_response = JSON.parse(response.body)
          expect( json_response.length ).to eq 0
        end
      end

      context 'and the source is unknown but topic is correct' do
        let(:param) { {topic: topic.name, source: 'unknown!'} }

        it 'response with success' do
          get :index, param
          expect(response).to have_http_status(:success)
        end

        it 'returns empty JSON array in response' do
          get :index, param
          json_response = JSON.parse(response.body)
          expect(json_response.length).to eq 0
        end
      end
    end
  end
end
