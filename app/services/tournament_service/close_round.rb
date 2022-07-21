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
        # Send a message to Twitter
        client = Twitter::REST::Client.new do |config|
          config.consumer_key        = Rails.application.credentials.dig(:twitter, :key)
          config.consumer_secret     = Rails.application.credentials.dig(:twitter, :key_secret)
          config.access_token        = Rails.application.credentials.dig(:twitter, :user_access_token)
          config.access_token_secret = Rails.application.credentials.dig(:twitter, :user_token_secret)
        end
        client.update("The winner of the #{@tournament.name} bracket is #{@tournament.contests.last.winner.entity.name}. https://bracket.today/bracket/#{@tournament.id}")
      end
    end
  end
end
