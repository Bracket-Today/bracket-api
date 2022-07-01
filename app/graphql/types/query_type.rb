# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :tournaments, [Types::TournamentType], null: false do
      argument :scopes, [String], required: false
    end

    def tournaments scopes: []
      relation = Tournament.all

      if scopes.include?('active')
        relation = relation.active
      elsif scopes.include?('activeAndRecent')
        relation = relation.active_and_recent
      end

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
