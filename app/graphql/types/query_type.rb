# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :tournaments, [Types::TournamentType], null: false do
      argument :scopes, [String], required: false
    end

    def tournaments scopes: []
      relation = Tournament.all
      relation = relation.active if scopes.include?('active')
      relation
    end

    field :tournament, Types::TournamentType, null: false do
      argument :id, ID, required: true
    end

    def tournament id:
      Tournament.find(id)
    end
  end
end
