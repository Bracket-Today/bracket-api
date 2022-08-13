# frozen_string_literal: true

module Types
  class CompetitorType < Types::BaseObject
    field :id, ID, null: false
    field :tournament, Types::TournamentType, null: false
    field :entity, Types::EntityType, null: false
    field :seed, Int, null: true

    field :vote_string, String, null: true

    def vote_string
      Rails.logger.info("!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!")
      Rails.logger.info("inside votes array")
      vote_array = []
      object.tournament.contests.each do |c|
        Rails.logger.info(c.inspect)
        vote_array << "Round #{c.round}: #{object.votes.where(contest_id: c.id).count}"
      end
      vote_array.join(" | ")
    end

  end
end
