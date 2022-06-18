# frozen_string_literal: true

module TournamentService
  class UpdateRounds
    include Service

    def call
      Tournament.ready_to_activate.each do |tournament|
        tournament.create_contests!
        tournament.update!(status: 'Active')
      end

      Tournament.active.all.each do |tournament|
        1...(tournament.current_round_by_time).each do |round_number|
          TournamentService::CloseRound.call(
            tournament: tournament,
            round: round
          )
        end
      end
    end
  end
end
