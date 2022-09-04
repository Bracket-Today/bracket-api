# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Competitor, type: :model do
  subject(:competitor) { FactoryBot.build(:competitor) }

  it { is_expected.to be_valid }

  describe 'scopes' do
    let!(:competitors) do
      [
        FactoryBot.create(:competitor, seed: 2),
        FactoryBot.create(:competitor, seed: 1),
        FactoryBot.create(:competitor, seed: 2),
      ]
    end

    describe '.ordered' do
      subject { Competitor.ordered }
      it { is_expected.to scope_as(competitors, [1,0,2]) }
    end
  end

  it { is_expected.to belong_to(:entity) }
  it { is_expected.to belong_to(:tournament) }

  describe 'destroy_empty_entity (called after destroy)' do
    before(:each) { competitor.save! }

    context 'entity has no other competitors' do
      it 'destroy entity' do
        expect { competitor.destroy }.to change { Entity.count }.by(-1)
        expect(Entity.find_by_id(competitor.entity)).to be(nil)
      end
    end

    context 'entity has other competitor' do
      before(:each) { FactoryBot.create :competitor, entity: competitor.entity }

      it 'does not destroy entity' do
        expect { competitor.destroy }.to_not change { Entity.count }
        expect(Entity.find_by_id(competitor.entity)).to_not be(nil)
      end
    end
  end
end
