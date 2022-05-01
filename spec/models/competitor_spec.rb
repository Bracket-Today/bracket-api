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
end
