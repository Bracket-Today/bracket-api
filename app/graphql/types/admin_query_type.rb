# frozen_string_literal: true

module Types
  class AdminQueryType < Types::BaseObject
    field :tournaments, [Types::TournamentType], null: false do
      argument :statuses, [String], required: false
    end

    def tournaments statuses: nil
      relation = Tournament.all
      if statuses.present?
        relation = relation.where(status: statuses)
      end
    end

    field :tournament, Types::TournamentType, null: true do
      argument :id, ID, required: true
    end

    def tournament id:
      ShortCode.resource(id, type: 'Tournament') || Tournament.find_by_id(id)
    end
  end
end
