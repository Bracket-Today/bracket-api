# frozen_string_literal: true

module Types
  class AdminQueryType < Types::BaseObject
    field :tournaments, [Types::TournamentType], null: false

    def tournaments
      Tournament.all
    end

    field :tournament, Types::TournamentType, null: true do
      argument :id, ID, required: true
    end

    def tournament id:
      ShortCode.resource(id, type: 'Tournament') || Tournament.find_by_id(id)
    end
  end
end
