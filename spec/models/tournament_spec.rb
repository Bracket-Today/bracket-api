# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tournament, type: :model do
  subject(:tournament) { FactoryBot.build(:tournament) }

  it { is_expected.to be_valid }

  describe 'scopes' do
    let!(:tournaments) do
      [
        FactoryBot.create(
          :tournament, status: 'Building', start_at: 2.days.from_now
        ),
        FactoryBot.create(
          :tournament, status: 'Seeding', start_at: 1.day.from_now
        ),
        FactoryBot.create(
          :tournament, status: 'Pending', start_at: 5.minutes.from_now
        ),
        FactoryBot.create(
          :tournament, status: 'Pending', start_at: 1.minute.ago
        ),
        FactoryBot.create(:tournament, status: 'Active'),
        FactoryBot.create(:tournament, status: 'Closed'),
      ]
    end

    describe '.ordered' do
      subject { Tournament.ordered }
      it { is_expected.to scope_as(tournaments, [0,1,2,3,4,5]) }
    end

    describe '.ready_to_activate' do
      subject { Tournament.ready_to_activate }
      it { is_expected.to scope_as(tournaments, [3]) }
    end

    describe '.active' do
      subject { Tournament.active }
      it { is_expected.to scope_as(tournaments, [4]) }
    end
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :round_duration }
  it { is_expected.to validate_presence_of :start_at }
  it { is_expected.to validate_presence_of :status }

  it { is_expected.to have_many :competitors }
  it { is_expected.to have_many :contests }

  describe '#current_round_by_time' do
    it 'gets current round based on start_at and duration' do
      tournament.start_at = 5.days.from_now
      expect(tournament.current_round_by_time).to eq(0)

      tournament.start_at = 10.minutes.from_now
      expect(tournament.current_round_by_time).to eq(0)

      tournament.start_at = Time.now
      expect(tournament.current_round_by_time).to eq(1)

      tournament.start_at = 5.minutes.ago
      expect(tournament.current_round_by_time).to eq(1)

      tournament.start_at = 1.day.ago - 5.seconds
      expect(tournament.current_round_by_time).to eq(2)

      tournament.start_at = 58.hours.ago
      expect(tournament.current_round_by_time).to eq(3)

      tournament.round_duration = 48.hours
      expect(tournament.current_round_by_time).to eq(2)
    end
  end

  describe '#create_contests!' do
    before(:each) { tournament.save! }

    let!(:competitor_data) do
      [
        ['a', 1], ['b', 5], ['c', 4], ['d', 8],
        ['e', 3], ['f', 2], ['g', 6], ['h', 7],
      ]
    end

    let!(:competitors) do
      competitor_data.map do |name, seed|
        FactoryBot.create(
          :competitor,
          tournament: tournament,
          entity: FactoryBot.create(:entity, name: name),
          seed: seed
        )
      end
    end

    subject(:run) { tournament.create_contests! }

    def contest_data
      tournament.contests.map do |contest|
        [
          contest.round, contest.sort,
          contest.upper.try(:name), contest.lower.try(:name)
        ]
      end
    end

    it 'creates contests' do
      expected = [
        [1, 0, 'a', 'd'],
        [1, 1, 'c', 'b'],
        [1, 2, 'e', 'g'],
        [1, 3, 'f', 'h'],
        [2, 0, nil, nil],
        [2, 1, nil, nil],
        [3, 0, nil, nil],
      ]

      expect(tournament.contests.count).to eq(0)
      run

      expect(tournament.contests.count).to eq(7)
      expect(contest_data).to eq(expected)
    end

    context 'competitors not a power of 2' do
      let!(:competitor_data) do
        [
          ['a', 1], ['b', 5], ['c', 4], ['d', 8],
          ['e', 3], ['f', 2], ['g', 6], ['h', 7],
          ['x', 9], ['y', 10], ['z', 11]
        ]
      end

      it 'creates contests, including a play-in round' do
        expected = [
          [0, 0, 'g', 'z'],
          [0, 1, 'h', 'y'],
          [0, 2, 'd', 'x'],
          [1, 0, 'a', nil],
          [1, 1, 'c', 'b'],
          [1, 2, 'e', nil],
          [1, 3, 'f', nil],
          [2, 0, nil, nil],
          [2, 1, nil, nil],
          [3, 0, nil, nil],
        ]

        run

        expect(tournament.contests.count).to eq(10)
        expect(contest_data).to eq(expected)
      end

      context 'play-in round affects upper competitors' do
        let!(:competitor_data) do
          [
            ['a', 1], ['b', 5], ['c', 4], # ['d', 8],
            ['e', 3], ['f', 2], ['g', 6], ['h', 7],
          ]
        end

        it 'creates contests, including a play-in round' do
          expected = [
            [0, 0, 'f', 'h'],
            [0, 1, 'e', 'g'],
            [0, 2, 'c', 'b'],
            [1, 0, 'a', nil],
            [1, 1, nil, nil],
            [2, 0, nil, nil],
          ]

          run

          expect(tournament.contests.count).to eq(6)
          expect(contest_data).to eq(expected)
        end
      end
    end

    context 'has any contests' do
      before(:each) { FactoryBot.create(:contest, tournament: tournament) }

      it 'raises ContestsExistError' do
        expect { run }.to raise_error(Tournament::ContestsExistError)
      end
    end
  end
end
