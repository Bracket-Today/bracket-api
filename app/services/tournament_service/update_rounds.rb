# frozen_string_literal: true

module TournamentService
  class UpdateRounds
    include Service

    def call
      Tournament.ready_to_activate.each do |tournament|
        tournament.reseed!
        tournament.create_contests! if tournament.contests.empty?
        tournament.update!(status: 'Active')

        # Send a message to Twitter
        TwitterService::Post.call(
          "Today's bracket is out! Vote for #{tournament.name} now. " +
          " https://bracket.today#{tournament.bracket_path}"
        )
      end

      Tournament.active.all.each do |tournament|
        current_round = tournament.current_round_by_time(ignore_max: true)
        (1...current_round).each do |round_number|
          TournamentService::CloseRound.call(
            tournament: tournament,
            round: round_number,
          )
        end
      end
    end
  end
end
