# frozen_string_literal: true

module TournamentService
  class UpdateRounds
    include Service

    def call
      Tournament.ready_to_activate.each do |tournament|
        tournament.create_contests! if tournament.contests.empty?
        tournament.update!(status: 'Active')

        # Send a message to Twitter
        client = Twitter::REST::Client.new do |config|
          config.consumer_key        = Rails.application.credentials.dig(:twitter, :key)
          config.consumer_secret     = Rails.application.credentials.dig(:twitter, :key_secret)
          config.access_token        = Rails.application.credentials.dig(:twitter, :user_access_token)
          config.access_token_secret = Rails.application.credentials.dig(:twitter, :user_token_secret)
        end
        client.update("Today's bracket is out! Vote for #{tournament.name} now. https://bracket.today/bracket/#{tournament.id}")
      end

      Tournament.active.all.each do |tournament|
        (1...(tournament.current_round_by_time)).each do |round_number|
          TournamentService::CloseRound.call(
            tournament: tournament,
            round: round_number,
          )
        end
      end
    end
  end
end
