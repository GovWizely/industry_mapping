require 'spec_helper'

describe Api::V1::IndustriesController, type: :controller do
  render_views


    #sector
    #topic
    #source
  let(:query) { {} }
  let(:get_index) { get :index, query }
  let(:json_response) { JSON.parse(response.body) }

  context 'topic only' do
    let(:topic) { create(:topic) }

    context 'when query matches' do
      let(:query) { {topic: topic.name} }

      it 'responds as expected' do
        get_index
        expect(json_response.count).to eq(1)
        expect(json_response.first['name']).to eq(topic.sector.industry.name)
      end
    end

    context "when query doesn't match" do
      let(:query) { {topic: topic.name.concat("won't match")} }

      it 'responds as expected' do
        get_index
        expect(json_response.count).to eq(0)
      end
    end
  end

  context 'source only' do
    let(:topic) { create(:topic) }
    let(:json_response) { JSON.parse(response.body) }

    context 'when query matches' do
      let(:query) { {source: topic.source.name} }

      context 'with one topic matching the source' do
        it 'contains the industry of the topic' do
          get_index
          expect(json_response.count).to eq(1)
          expect(json_response.first['name']).to eq(topic.sector.industry.name)
        end
      end

      context 'with multiple topics matching the source' do
        let!(:topic2) { create(:topic, source: topic.source) }

        it 'contains the industries of both topics' do
          get_index
          expect(json_response.count).to eq(2)
          expect(json_response).to match_array(
            [topic, topic2].map { |t| {'id' => t.industry.id, 'name' => t.industry.name } }
          )
        end
      end
    end

    context "when query doesn't match" do
      let(:query) { {source: topic.source.name.concat("won't match")} }

      it 'responds as expected' do
        get_index
        expect(json_response.count).to eq(0)
      end
    end
  end

  context 'sector only' do
  end

  context 'topic and source' do
# Check that no Failed Lookup was created.
  end

  context 'topic and sector' do
  end

  context 'source and sector' do
  end

  context 'all params' do
  end

  context 'when requesting to log failed lookups' do
    context 'with source and topic' do
      context "when source doesn't exist" do
        let(:topic_name) { 'Foo Bar' }
        let(:source_name) { 'Foo::Bar' }
        let(:query) { {source: source_name, topic: topic_name, log_failed: 'true'} }

        it 'creates the new Topic and source' do
          get_index
          expect(json_response.count).to eq(0)

          source = Source.find_by(name: source_name)
          expect(source).to be

          topic = Topic.find_by(name: topic_name, source: source)
          expect(topic).to be
          expect(topic.sector).to be_nil
          expect(topic.industry).to be_nil
        end
      end

      context 'when source already exists' do
      end
    end
  end


  #context 'when endpoint is unknown' do

    #it { is_expected.to respond_with(:success) }

    #it 'has no industries in response' do
      #json_response = JSON.parse(response.body)
      #expect(json_response.count).to eq(0)
    #end
  #end

  #describe 'industries endpoint' do
    #context 'when only topic param is present' do
      #context 'and is right name' do
        #before { get :index, topic: topic.name }

        #it { is_expected.to respond_with(:success) }

        #it 'has correct JSON in response' do
          #json_response = JSON.parse(response.body)
          #expect(json_response[0]['id']).to eq( topic.sector.industry.id)
          #expect(json_response[0]['name']).to eq( topic.sector.industry.name)
        #end
      #end

      #context 'and wrong name' do
        #before { get :index, topic: 'unknown!' }

        #it { is_expected.to respond_with(:success) }

        #it 'returns empty JSON array in response' do
          #json_response = JSON.parse(response.body)
          #expect( json_response.length ).to eq 0
        #end
      #end
      #it "does not change Topic number" do
        #expect { get :index, topic: topic.name }.to_not change{ Topic.count }
        #expect { get :index, topic: 'unknown!' }.to_not change{ Topic.count }
      #end
    #end

    #context 'when topic param and source are present' do
      #context 'and are right named' do
        #before { get :index, topic: topic.name, source: topic.source.name }

        #it { is_expected.to respond_with(:success) }

        #it 'has correct JSON in response' do
          #json_response = JSON.parse(response.body)
          #expect( json_response[0]['id']).to eq( topic.sector.industry.id)
          #expect( json_response[0]['name']).to eq( topic.sector.industry.name)
        #end
      #end

      #context 'and the topic is unknown' do
        #let(:param) { {topic: 'unknown!', source: topic.source.name} }

        #it 'responds with success' do
          #get :index, param
          #expect(response).to have_http_status(:success)
        #end

        #it 'returns empty JSON array in response' do
          #get :index, param
          #json_response = JSON.parse(response.body)
          #expect( json_response.length ).to eq 0
        #end
      #end

      #context 'and the source is unknown but topic is correct' do
        #let(:param) { {topic: topic.name, source: 'unknown!'} }

        #it 'response with success' do
          #get :index, param
          #expect(response).to have_http_status(:success)
        #end

        #it 'returns empty JSON array in response' do
          #get :index, param
          #json_response = JSON.parse(response.body)
          #expect(json_response.length).to eq 0
        #end
      #end
    #end
  #end
end
