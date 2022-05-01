# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contest, type: :model do
  subject(:contest) { FactoryBot.build(:contest) }

  it { is_expected.to be_valid }

  describe 'scopes' do
    let!(:contests) do
      [
        FactoryBot.create(:contest, round: 2, sort: 1),
        FactoryBot.create(:contest, round: 2, sort: 3),
        FactoryBot.create(:contest, round: 1, sort: 2),
      ]
    end

    describe '.ordered' do
      subject { Contest.ordered }
      it { is_expected.to scope_as(contests, [2,0,1]) }
    end
  end

  it { is_expected.to belong_to(:tournament) }
  it { is_expected.to belong_to(:upper).optional }
  it { is_expected.to belong_to(:lower).optional }
  it { is_expected.to belong_to(:winner).optional }

  it { is_expected.to validate_presence_of :round }
  it { is_expected.to validate_presence_of :sort }
end
