# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :login_code, String, null: true
    field :username, String, null: true
    field :tournament, Types::TournamentType, null: true do
      argument :id, ID, required: true
    end
    field :tournaments, [Types::TournamentType], null: false
    field :votes_count, Int, null: false

    def tournament id:
      object.tournaments.find_by_id(id)
    end

    def votes_count
      object.votes.count
    end
  end
end
