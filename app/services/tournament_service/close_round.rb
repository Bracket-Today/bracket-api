# frozen_string_literal: true

module TournamentService
  class CloseRound
    include Service

    def initialize tournament:, round:
      @tournament, @round = tournament, round
    end

    def call
      @tournament.round(@round)[:contests].each do |contest|
        contest.won! unless contest.winner
      end
    end
  end
end
