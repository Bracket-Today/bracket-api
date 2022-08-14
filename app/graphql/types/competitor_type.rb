# frozen_string_literal: true

module Types
  class CompetitorType < Types::BaseObject
    field :id, ID, null: false
    field :tournament, Types::TournamentType, null: false
    field :entity, Types::EntityType, null: false
    field :seed, Int, null: true
    field :votes, [Types::VoteType], null: true

    field :vote_string, String, null: true

    def vote_string
      vote_array = []
      object.tournament.contests.order("round ASC").pluck(:round).uniq.each do |c|
        vote_array << "Round #{c}: #{object.votes.where(contest_id: object.tournament.contests.where(round: c).pluck(:id)).count}"
      end
      vote_array.join(" | ")
    end

  end
end
