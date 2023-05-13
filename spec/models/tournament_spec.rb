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
          :tournament, status: 'Pending', start_at: 1.minute.ago, featured: true
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

    describe '.featured' do
      subject { Tournament.featured }
      it { is_expected.to scope_as(tournaments, [3]) }
    end

    describe '.upcoming' do
      subject { Tournament.upcoming }
      it { is_expected.to scope_as(tournaments, [3, 2]) }
    end

    describe '.clone_suggestions' do
      subject { Tournament.clone_suggestions }

      before(:each) do
        closed = FactoryBot.create(:tournament, status: 'Closed')
        tournaments[0].update!(based_on: closed)
      end

      it { is_expected.to scope_as(tournaments, [5]) }
    end
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :round_duration }
  it { is_expected.to validate_presence_of :status }

  it { is_expected.to belong_to(:based_on).class_name('Tournament').optional }
  it { is_expected.to belong_to(:owner).class_name('User').optional }

  describe '#competitors' do
    it { is_expected.to have_many :competitors }

    it 'destroys competitors and any entities with no other competitors' do
      tournament.save!
      competitors =
        FactoryBot.create_list :competitor, 2, tournament: tournament

      entities = competitors.map(&:entity)
      FactoryBot.create :competitor, entity: entities[0]

      expect { tournament.destroy }.to change { Entity.count }.by(-1)
      expect(Competitor.find_by_id(competitors[0].id)).to be(nil)
      expect(Competitor.find_by_id(competitors[1].id)).to be(nil)
      expect(Entity.find_by_id(entities[0].id)).to_not be(nil)
      expect(Entity.find_by_id(entities[1].id)).to be(nil)
    end
  end

  it { is_expected.to have_many :comments }
  it { is_expected.to have_many :contests }
  it { is_expected.to have_many :external_links }
  it { is_expected.to have_many :short_codes }

  describe '#short_code' do
    before(:each) { tournament.save! }
    subject { tournament.short_code }

    context 'existing short_code' do
      before(:each) do
        FactoryBot.create(:short_code, resource: tournament, code: 'abc12-')
      end

      it { is_expected.to eq('abc12-') }
    end

    context 'no existing short_code' do
      it { is_expected.to_not eq('abc12-') }
      it { is_expected.to be_a(String) }
    end
  end

  describe '#short_path' do
    before(:each) { tournament.save! }
    subject { tournament.short_path }

    before(:each) do
      FactoryBot.create(:short_code, resource: tournament, code: 'abc12-')
    end

    it { is_expected.to eq('/~/abc12-') }
  end

  describe '#full_path' do
    before(:each) do
      tournament.name = 'Test 123'
      tournament.save!
    end

    subject { tournament.full_path }

    before(:each) do
      tournament.save
      FactoryBot.create(:short_code, resource: tournament, code: 'abc13-')
    end

    it { is_expected.to eq('/tournaments/abc13-/test-123') }
  end

  describe '#bracket_path' do
    before(:each) do
      tournament.name = 'Test 123'
      tournament.save!
    end

    subject { tournament.bracket_path }

    before(:each) do
      tournament.save
      FactoryBot.create(:short_code, resource: tournament, code: 'abc13-')
    end

    it { is_expected.to eq('/bracket/abc13-/test-123') }
  end

  describe '#current_round_by_time' do
    before(:each) do
      tournament.save!

      3.times do |i|
        FactoryBot.create(:contest, tournament: tournament, round: i + 1)
      end
    end

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

      tournament.start_at = 58.days.ago
      expect(tournament.current_round_by_time).to eq(3)

      tournament.start_at = nil
      expect(tournament.current_round_by_time).to eq(0)
    end
  end

  describe '#round_duration_unit and #round_duration_quantity' do
    it 'gets best quantity and unit for round duration' do
      expect(tournament.round_duration_quantity).to eq(1)
      expect(tournament.round_duration_unit).to eq(:day)

      tournament.round_duration = 10
      expect(tournament.round_duration_quantity).to eq(10)
      expect(tournament.round_duration_unit).to eq(:second)

      tournament.round_duration = 120
      expect(tournament.round_duration_quantity).to eq(2)
      expect(tournament.round_duration_unit).to eq(:minute)

      tournament.round_duration = 125
      expect(tournament.round_duration_quantity).to eq(125)
      expect(tournament.round_duration_unit).to eq(:second)

      tournament.round_duration = 7200
      expect(tournament.round_duration_quantity).to eq(2)
      expect(tournament.round_duration_unit).to eq(:hour)

      tournament.round_duration = 7260
      expect(tournament.round_duration_quantity).to eq(121)
      expect(tournament.round_duration_unit).to eq(:minute)

      tournament.round_duration = 259200
      expect(tournament.round_duration_quantity).to eq(3)
      expect(tournament.round_duration_unit).to eq(:day)

      tournament.round_duration = 266400
      expect(tournament.round_duration_quantity).to eq(74)
      expect(tournament.round_duration_unit).to eq(:hour)
    end
  end

  describe '#reseed!' do
    let!(:competitors) do
      tournament.save!

      [
        FactoryBot.create(:competitor, tournament: tournament, seed: 2),
        FactoryBot.create(:competitor, tournament: tournament, seed: nil),
        FactoryBot.create(:competitor, tournament: tournament, seed: 3),
        FactoryBot.create(:competitor, tournament: tournament, seed: 3),
      ]
    end

    it 'ensures seeds are 1..competitors.length' do
      tournament.reseed!
      expect(Competitor.find(competitors[0].id).seed).to eq(1)
      expect(Competitor.find(competitors[1].id).seed).to eq(4)
      expect(Competitor.find(competitors[2].id).seed).to eq(2)
      expect(Competitor.find(competitors[3].id).seed).to eq(3)
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
          [1, 0, 'a', nil],
          [1, 1, 'd', 'x'],
          [1, 2, 'b', nil],
          [1, 3, 'c', nil],
          [1, 4, 'g', 'z'],
          [1, 5, 'e', nil],
          [1, 6, 'h', 'y'],
          [1, 7, 'f', nil],
          [2, 0, 'a', nil],
          [2, 1, 'b', 'c'],
          [2, 2, nil, 'e'],
          [2, 3, nil, 'f'],
          [3, 0, nil, nil],
          [3, 1, nil, nil],
          [4, 0, nil, nil],
        ]

        run

        expect(tournament.contests.count).to eq(15)
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
            [1, 0, 'a', nil],
            [1, 1, 'c', 'b'],
            [1, 2, 'e', 'g'],
            [1, 3, 'f', 'h'],
            [2, 0, 'a', nil],
            [2, 1, nil, nil],
            [3, 0, nil, nil],
          ]

          run

          expect(tournament.contests.count).to eq(7)
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

    describe '#view_comments?' do
      it 'returns whether comments can be viewed' do
        expect(tournament.view_comments?).to be(false)
        Setting.active.update(comments_status: 'read-only')
        expect(tournament.view_comments?).to be(true)
        Setting.active.update(comments_status: 'enabled')
        expect(tournament.view_comments?).to be(true)

        tournament.comments_status = 'read-only'
        expect(tournament.view_comments?).to be(true)
        tournament.comments_status = 'disabled'
        expect(tournament.view_comments?).to be(false)
      end
    end

    describe '#make_comments?' do
      it 'returns whether comments can be created (and potentially edited)' do
        expect(tournament.make_comments?).to be(false)
        Setting.active.update(comments_status: 'read-only')
        expect(tournament.make_comments?).to be(false)
        Setting.active.update(comments_status: 'enabled')
        expect(tournament.make_comments?).to be(true)

        tournament.comments_status = 'read-only'
        expect(tournament.make_comments?).to be(false)
        tournament.comments_status = 'disabled'
        expect(tournament.make_comments?).to be(false)
      end
    end

    describe '.duration_in_seconds' do
      it 'converts duration based on units' do
        expect(Tournament.duration_in_seconds(5, :second)).to eq(5)
        expect(Tournament.duration_in_seconds(5, :minute)).to eq(300)
        expect(Tournament.duration_in_seconds(5, :hour)).to eq(18000)
        expect(Tournament.duration_in_seconds(5, :day)).to eq(432_000)
      end
    end
  end
end
