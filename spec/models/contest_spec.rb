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

  it { is_expected.to have_many(:votes) }

  it { is_expected.to validate_presence_of :round }
  it { is_expected.to validate_presence_of :sort }

  describe '#active?' do
    subject { contest.active? }

    it { is_expected.to be(false) }

    context 'has competitors' do
      before :each do
        contest.upper = FactoryBot.create(:competitor)
        contest.lower = FactoryBot.create(:competitor)
      end

      context 'no winner' do
        it { is_expected.to be(true) }
      end

      context 'has winner' do
        before(:each) { contest.winner = contest.upper }
        it { is_expected.to be(false) }
      end
    end

    context 'only upper competitor' do
      before :each do
        contest.upper = FactoryBot.create(:competitor)
      end

      it { is_expected.to be(false) }
    end

    context 'only lower competitor' do
      before :each do
        contest.lower = FactoryBot.create(:competitor)
      end

      it { is_expected.to be(false) }
    end
  end

  describe '#winner_contest' do
    let!(:tournament) { FactoryBot.create(:tournament) }
    let!(:contests) do
      [[3,0], [1,0], [1,1], [1,3], [1,2], [2,1], [2,0]].map do |round, sort|
        FactoryBot.create(
          :contest, tournament: tournament, round: round, sort: sort
        )
      end
    end

    it 'is the contest in which the winner will participate' do
      expect(contests[1].winner_contest).to eq(contests[6])
      expect(contests[2].winner_contest).to eq(contests[6])
      expect(contests[3].winner_contest).to eq(contests[5])
      expect(contests[4].winner_contest).to eq(contests[5])
      expect(contests[5].winner_contest).to eq(contests[0])
      expect(contests[6].winner_contest).to eq(contests[0])
    end

    context 'final_round' do
      subject { contests[0].winner_contest }

      it { is_expected.to be(nil) }
    end
  end

  describe '#won!' do
    let!(:tournament) { FactoryBot.create(:tournament) }
    let!(:contests) do
      [[3,0], [2,1], [2,0]].map do |round, sort|
        FactoryBot.create(
          :contest, tournament: tournament, round: round, sort: sort
        )
      end
    end

    it 'sets winner and next contest' do
      expect(contests[0].upper).to be(nil)
      contests[2].won!(contests[2].upper)
      expect(contests[0].reload.upper).to be(contests[2].upper)
      expect(contests[2].winner).to eq(contests[2].upper)

      expect(contests[0].lower).to be(nil)
      contests[1].won!(contests[1].lower)
      expect(contests[0].reload.lower).to be(contests[1].lower)

      contests[0].won!(contests[1].lower)
      expect(contests[0].winner).to eq(contests[1].lower)
    end
  end
end
