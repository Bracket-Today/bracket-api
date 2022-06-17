# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TournamentService::CloseRound do
  describe '#call' do
    let! :tournament do
      FactoryBot.create(:tournament)
    end

    let! :competitors do
      FactoryBot.create_list(:competitor, 8, tournament: tournament)
    end

    before(:each) do
      tournament.create_contests!
    end

    it 'sets winners of contests in round if not set' do
      tournament.contests[0].update!(winner: tournament.contests[0].lower)

      expect(tournament.contests[1].winner).to be(nil)

      TournamentService::CloseRound.call(tournament: tournament, round: 1)

      tournament.reload
      expect(tournament.contests[0].winner).to eq(tournament.contests[0].lower)
      expect(tournament.contests[0].winner).to_not be(nil)
      expect(tournament.contests[1].winner).to eq(tournament.contests[1].upper)
      expect(tournament.contests[1].winner).to_not be(nil)
      expect(tournament.contests[2].winner).to eq(tournament.contests[2].upper)
      expect(tournament.contests[3].winner).to eq(tournament.contests[3].upper)
      expect(tournament.contests[4].winner).to be(nil)
      expect(tournament.contests[5].winner).to be(nil)
      expect(tournament.contests[6].winner).to be(nil)

      TournamentService::CloseRound.call(tournament: tournament, round: 2)

      tournament.reload
      expect(tournament.contests[4].winner).to eq(tournament.contests[1].upper)
      expect(tournament.contests[5].winner).to eq(tournament.contests[3].upper)
      expect(tournament.contests[6].winner).to be(nil)
    end
  end
end
