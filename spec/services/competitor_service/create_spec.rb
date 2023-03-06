# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompetitorService::Create do
  let!(:tournament) { FactoryBot.create(:tournament) }
  let!(:existing_entity) { FactoryBot.create(:entity, name: 'Entity') }

  subject(:service) do
    CompetitorService::Create.new(tournament: tournament, **attributes)
  end

  describe '#call' do
    let(:attributes) do
      { name: 'Test' }
    end

    it 'returns Competitor' do
      competitor = service.call[:competitor]
      expect(competitor).to be_a(Competitor)
      expect(competitor.name).to eq('Test')
      expect(competitor.seed).to eq(1)
      expect(competitor.new_record?).to be(true)
    end

    it 'creates Entity' do
      result = nil
      expect { result = service.call }.to change { Entity.count }.by(1)
      competitor = result[:competitor]
      entity = Entity.order(:id).last
      expect(competitor.entity).to eq(entity)
      expect(entity.name).to eq('Test')
    end

    context 'given entity' do
      let(:attributes) do
        { name: 'Test', entity: existing_entity }
      end

      it 'sets up competitor but uses existing Entity' do
        result = nil
        expect { result = service.call }.to_not change { Entity.count }
        competitor = result[:competitor]
        expect(competitor.entity).to eq(existing_entity)
        expect(competitor.name).to eq('Entity')
      end
    end

    context 'entity is :match' do
      let(:attributes) do
        { name: 'Test', entity: :match }
      end

      context 'name matches existing entity' do
        let(:attributes) do
          { name: 'Entity', entity: :match }
        end

        it 'sets up competitor but uses existing Entity' do
          result = nil
          expect { result = service.call }.to_not change { Entity.count }
          competitor = result[:competitor]
          expect(competitor.entity).to eq(existing_entity)
          expect(competitor.name).to eq('Entity')
        end
      end

      context 'no existing entity matched by name' do
        it 'creates Entity' do
          result = nil
          expect { result = service.call }.to change { Entity.count }.by(1)
          competitor = result[:competitor]
          entity = Entity.order(:id).last
          expect(competitor.entity).to eq(entity)
          expect(entity.name).to eq('Test')
        end
      end
    end

    context 'given entity_annotation' do
      context 'entity does not have existing annotation' do
        let(:attributes) do
          { name: 'Test', entity: existing_entity, entity_annotation: 'EA' }
        end

        it 'sets annotation on competitor' do
          result = service.call
          competitor = result[:competitor]
          expect(competitor.entity).to eq(existing_entity)
          expect(competitor.entity.annotation).to eq('EA')
          expect(competitor.annotation).to be(nil)
        end
      end

      context 'entity has existing annotation' do
        let!(:existing_entity) do
          FactoryBot.create(:entity, name: 'Entity', annotation: 'Existing')
        end

        let(:attributes) do
          { name: 'Test', entity: existing_entity, entity_annotation: 'EA' }
        end

        it 'sets annotation on competitor' do
          result = service.call
          competitor = result[:competitor]
          expect(competitor.entity).to eq(existing_entity)
          expect(competitor.entity.annotation).to eq('Existing')
          expect(competitor.annotation).to eq('EA')
        end
      end
    end

    context 'given (competitor) annotation' do
      let(:attributes) do
        { name: 'Test', annotation: 'Annotation' }
      end

      it 'sets annotation on competitor' do
        result = service.call
        competitor = result[:competitor]
        expect(competitor.entity.annotation).to be(nil)
        expect(competitor.annotation).to eq('Annotation')
      end
    end

    context 'given seed' do
      let(:attributes) do
        { name: 'Test', seed: 10 }
      end

      it 'sets seed on competitor' do
        result = service.call
        competitor = result[:competitor]
        expect(competitor.seed).to eq(10)
      end
    end

    context 'no seed given but existing competitors' do
      before(:each) do
        FactoryBot.create(:competitor, tournament: tournament)
        FactoryBot.create(:competitor, tournament: tournament)
      end

      it 'sets seed based on competitors count' do
        result = service.call
        competitor = result[:competitor]
        expect(competitor.seed).to eq(3)
      end
    end

    context 'given urls' do
      let(:attributes) do
        {
          name: 'Test',
          entity: existing_entity,
          urls: ['http://example.com', 'http://example.org']
        }
      end

      let!(:external_link) do
        FactoryBot.create(
          :external_link,
          owner: existing_entity,
          url: 'http://example.com'
        )
      end

      it 'adds ExternalLink to entity' do
        result = nil
        expect { result = service.call }.to change { ExternalLink.count }.by(1)
        competitor = result[:competitor]
        expect(competitor.entity.external_links.order(:id).map(&:url)).
          to eq(['http://example.com', 'http://example.org'])
      end
    end
  end
end
