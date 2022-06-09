# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :tournaments, [Types::TournamentType], null: false

    def tournaments
      Tournament.all
    end

    field :tournament, Types::TournamentType, null: false do
      argument :id, ID, required: true
    end

    def tournament id:
      Tournament.find(id)
    end
  end
end
