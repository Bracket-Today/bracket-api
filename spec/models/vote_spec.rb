# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  subject(:vote) { FactoryBot.build(:vote) }

  it { is_expected.to be_valid }

  it { is_expected.to belong_to(:contest) }
  it { is_expected.to belong_to(:competitor) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:contest_id) }

  describe '#active_contest validation' do
    before(:each) do
      vote.competitor.save!
      vote.contest.save!
      vote.contest.update!(upper: vote.competitor)
    end

    subject { vote.valid? }

    context 'contest has no winner' do
      it { is_expected.to be(true) }

      context 'contest missing a competitor' do
        before(:each) { vote.contest.update!(upper: nil) }

        it { is_expected.to be(false) }
      end
    end

    context 'contest has a winner' do
      before(:each) { vote.contest.update!(winner: vote.competitor) }
      it { is_expected.to be(false) }
    end
  end

  describe '#competitor_in_contest validation' do
    before(:each) do
      vote.competitor.save!
      vote.contest.save!
    end

    subject { vote.valid? }

    context 'competitor is contest#upper' do
      before(:each) { vote.contest.upper = vote.competitor }
      it { is_expected.to be(true) }
    end

    context 'competitor is contest#lower' do
      before(:each) { vote.contest.lower = vote.competitor }
      it { is_expected.to be(true) }
    end

    context 'competitor is not in contest' do
      before(:each) do
        vote.competitor = FactoryBot.create(:competitor)
      end

      it { is_expected.to be(false) }
    end
  end
end
