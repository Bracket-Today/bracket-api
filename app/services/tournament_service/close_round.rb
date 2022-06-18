# frozen_string_literal: true

module TournamentService
  class CloseRound
    include Service

    def initialize tournament:, round:
      @tournament, @round = tournament, round
    end

    def call
      @tournament.contests.where(round: @round).each do |contest|
        contest.won! unless contest.winner
      end

      if @tournament.contests.where(winner_id: nil).empty?
        @tournament.update(status: 'Closed')
      end
    end
  end
end
