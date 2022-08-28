# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.build(:user) }

  it { is_expected.to be_valid }

  describe 'scopes' do
    let! :users do
      [
        FactoryBot.create(
          :user, provider: 'email',
          email: 'test@example.com', password: 'Tester123'
        ),
        FactoryBot.create(:user, provider: 'uuid'),
        FactoryBot.create(:user),
      ]
    end

    describe '.uuid' do
      subject { User.uuid.ordered }
      it { is_expected.to scope_as(users, [1,2]) }
    end
  end

  it { is_expected.to have_many(:tournaments) }
  it { is_expected.to have_many(:votes) }

  describe '#login_code' do
    subject { user.login_code }

    context 'existing login_code' do
      before(:each) { user.login_code = 'abc12_' }
      it { is_expected.to eq('abc12_') }
    end

    context 'no existing login_code' do
      before(:each) { user.login_code = nil }
      it { is_expected.to_not eq('abc12_') }
      it { is_expected.to be_a(String) }
    end
  end

  describe '#generate_login_code' do
    it 'sets login_code with new code' do
      user.save!
      code = user.generate_login_code
      expect(User.find(user.id).login_code).to eq(code)
      expect(code).to be_a(String)
      expect(code.length).to eq(6)
      expect(code).to_not include('_')
      expect(code).to_not include('-')
      expect(code).to_not match(/\s/)
    end
  end

  describe '#should_vote?' do
    subject { user.should_vote? }

    let!(:tournaments) do
      [
        FactoryBot.create(:tournament, status: 'Active', start_at: 1.hour.ago),
        FactoryBot.create(:tournament, status: 'Pending'),
      ]
    end

    let!(:contests) do
      [
        FactoryBot.create(
          :contest, :with_competitors, tournament: tournaments.first, round: 1
        ),
        FactoryBot.create(
          :contest, :with_competitors, tournament: tournaments.first, round: 2
        ),
        FactoryBot.create(
          :contest, :with_competitors, tournament: tournaments.last, round: 1
        ),
      ]
    end

    def vote! contest
      Vote.create!(
        contest: contests[0],
        competitor: contests[0].upper,
        user: user
      )
    end

    it { is_expected.to be(true) }

    context 'all active contests voted' do
      before(:each) { vote! contests[0] }
      it { is_expected.to be(false) }
    end

    context 'contest specified' do
      subject { user.should_vote? contest: contests[0] }

      context 'contest is active' do
        context 'has not voted' do
          it { is_expected.to be(true) }
        end

        context 'has voted' do
          before(:each) { vote! contests[0] }
          it { is_expected.to be(false) }
        end
      end

      context 'contest is not active' do
        subject { user.should_vote? contest: contests[1] }
        it { is_expected.to be(false) }
      end
    end

    context 'tournament specified' do
      subject { user.should_vote? tournament: tournaments[0] }

      context 'trournament is active' do
        context 'has not voted' do
          it { is_expected.to be(true) }
        end

        context 'has voted' do
          before(:each) { vote! contests[0] }
          it { is_expected.to be(false) }
        end

        context 'no active contests' do
          before(:each) { contests[0].update!(winner: contests[0].upper) }
          it { is_expected.to be(false) }
        end
      end

      context 'tournament is not active' do
        before(:each) { tournaments[0].update!(status: 'Pending') }
        it { is_expected.to be(false) }
      end
    end
  end

  describe '#next_tournament_to_vote' do
    subject { user.next_tournament_to_vote }

    let!(:tournament) do
      FactoryBot.create(:tournament, status: 'Active', start_at: 1.hour.ago)
    end

    let!(:contest) do
      FactoryBot.create(
        :contest, :with_competitors, tournament: tournament, round: 1
      )
    end

    it { is_expected.to eq(tournament) }

    context 'no tournaments where user should vote' do
      before(:each) do
        Vote.create!(contest: contest, competitor: contest.upper, user: user)
      end

      it { is_expected.to be(nil) }
    end
  end

  describe '.by_uuid' do
    let!(:existing) do
      [
        FactoryBot.create(:user, uid: 'A'),
        FactoryBot.create(:user, uid: 'B'),
      ]
    end

    context 'existing user with uuid' do
      subject { User.by_uuid('A') }

      it { is_expected.to eq(existing[0]) }

      it 'does not create a User' do
        expect { User.by_uuid('A') }.to_not change { User.count }
      end
    end

    context 'no existing user with uuid' do
      subject { User.by_uuid('C') }

      it { is_expected.to be_a(User) }

      it 'creates a User' do
        expect { User.by_uuid('C') }.to change { User.count }
      end
    end
  end
end
