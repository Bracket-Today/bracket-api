# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  subject(:vote) { FactoryBot.build(:vote) }

  it { is_expected.to be_valid }

  it { is_expected.to belong_to(:contest) }
  it { is_expected.to belong_to(:competitor) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:contest_id) }

  describe '#competitor_in_contest validation' do
    before(:each) do
      vote.competitor.save!
      vote.contest.save!
    end

    subject { vote.valid? }

    context 'competitor is contest#upper' do
      before(:each) { vote.contest.update!(upper: vote.competitor) }
      it { is_expected.to be(true) }
    end

    context 'competitor is contest#lower' do
      before(:each) { vote.contest.update!(lower: vote.competitor) }
      it { is_expected.to be(true) }
    end

    context 'competitor is not in contest' do
      before(:each) do
        vote.contest.update!(upper: FactoryBot.create(:competitor))
      end

      it { is_expected.to be(false) }
    end
  end
end
