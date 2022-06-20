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

        context 'round less than current_round_by_time' do
          before(:each) { contest.tournament.start_at = 5.minutes.from_now }
          it { is_expected.to be(false) }
        end

        context 'round greater than current_round_by_time' do
          before(:each) { contest.tournament.start_at = 5.weeks.ago }
          it { is_expected.to be(false) }
        end
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

  describe 'vote counts' do
    let!(:upper) do
      FactoryBot.create(:competitor, tournament: contest.tournament, seed: 2)
    end

    let!(:lower) do
      FactoryBot.create(:competitor, tournament: contest.tournament, seed: 1)
    end

    before(:each) do
      contest.upper = upper
      contest.lower = lower
      contest.save!
    end

    let!(:votes) do
      [
        FactoryBot.create(:vote, contest: contest, competitor: upper),
        FactoryBot.create(:vote, contest: contest, competitor: upper),
        FactoryBot.create(:vote, contest: contest, competitor: lower),
        FactoryBot.create(
          :vote,
          competitor: upper,
          contest: FactoryBot.create(:contest, lower: upper, upper: lower)
        )
      ]
    end

    describe '#vote_count' do
      it 'gets count of votes for competitor' do
        expect(contest.vote_count(competitor: upper)).to eq(2)
        expect(contest.vote_count(competitor: lower)).to eq(1)
      end
    end

    describe '#upper_vote_count' do
      subject { contest.upper_vote_count }
      it { is_expected.to eq(2) }
    end

    describe '#lower_vote_count' do
      subject { contest.lower_vote_count }
      it { is_expected.to eq(1) }
    end

    describe '#leader' do
      subject { contest.leader }
      it { is_expected.to eq(upper) }

      context 'same votes' do
        before(:each) do
          FactoryBot.create(:vote, contest: contest, competitor: lower)
        end

        it { is_expected.to eq(lower) }
      end
    end
  end

  describe '#won!' do
    let!(:tournament) { FactoryBot.create(:tournament) }
    let!(:contests) do
      [[3,0], [2,1], [2,0]].map do |round, sort|
        FactoryBot.create(
          :contest, tournament: tournament, round: round, sort: sort,
          upper: (
            2 == round ?
            FactoryBot.create(:competitor, tournament: tournament) : nil
          ),
          lower: (
            2 == round ?
            FactoryBot.create(:competitor, tournament: tournament) : nil
          ),
        )
      end
    end

    it 'sets winner and next contest' do
      expect(contests[0].upper).to be(nil)
      contests[2].won!(contests[2].upper)
      expect(contests[0].reload.upper).to eq(contests[2].upper)
      expect(contests[2].winner).to eq(contests[2].upper)

      expect(contests[0].lower).to be(nil)
      contests[1].won!(contests[1].lower)
      expect(contests[0].reload.lower).to eq(contests[1].lower)

      contests[0].won!(contests[1].lower)
      expect(contests[0].winner).to eq(contests[1].lower)
    end

    context 'winner not given' do
      before(:each) do
        contests[1].tournament.update!(start_at: 25.hours.ago)

        FactoryBot.create(
          :vote, contest: contests[1], competitor: contests[1].lower
        )
      end

      it 'sets winner based on leader' do
        contests[1].won!
        expect(contests[1].reload.winner).to eq(contests[1].lower)

        contests[2].won!
        expect(contests[2].reload.winner).to eq(contests[2].upper)
      end
    end
  end
end
