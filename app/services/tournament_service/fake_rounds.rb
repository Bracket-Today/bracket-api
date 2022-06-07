# frozen_string_literal: true

module TournamentService
  class FakeRounds
    include Service

    def initialize tournament:, override: false, rounds: nil
      @tournament, @override, @rounds = tournament, override, rounds
    end

    def call
      @tournament.rounds.each do |round|
        break if @rounds && round[:number] > @rounds

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
