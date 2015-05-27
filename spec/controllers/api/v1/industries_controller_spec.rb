require 'spec_helper'

describe Api::V1::IndustriesController, type: :controller do
  render_views

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
        let(:topic) { create(:topic, sector: nil, industry: nil) }
        let(:query) { {source: topic.source.name, topic: topic.name, log_failed: 'true'} }
        before { get_index }
        it { expect(json_response.count).to eq(0) }
        subject { Source.find_by(name: topic.source.name) }
        it { expect(subject).to be }
        subject { Topic.find_by(name: topic.name, source: topic.source) }
        it { expect(subject).to be }
        it { expect(subject.sector).to be_nil }
        it { expect(subject.industry).to be_nil }
      end
    end
  end
end
