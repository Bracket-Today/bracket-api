# frozen_string_literal: true

module Types
  class AdminQueryType < Types::BaseObject
    field :tournaments, [Types::TournamentType], null: false do
      argument :statuses, [String], required: false
      argument :scopes, [String], required: false
    end

    def tournaments statuses: nil, scopes: []
      relation = Tournament.all
      if statuses.present?
        relation = relation.where(status: statuses)
      end

      if scopes.include?('clone_suggestions')
        relation = relation.clone_suggestions
      end

      relation
    end

    field :tournament, Types::TournamentType, null: true do
      argument :id, ID, required: true
    end

    def tournament id:
      ShortCode.resource(id, type: 'Tournament') || Tournament.find_by_id(id)
    end
  end
end
