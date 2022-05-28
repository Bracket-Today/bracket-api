# frozen_string_literal: true

module TournamentService
  class FakeRounds
    include Service

    def initialize tournament:, override: false
      @tournament, @override = tournament, override
    end

    def call
      @tournament.rounds.each do |round|
        round[:contests].each do |contest|
          contest.reload # rounds may have out-of-date entries
          next if contest.winner && !@override

          winner = [contest.upper, contest.lower].sample
          contest.won! winner
        end
      end
    end
  end
end
