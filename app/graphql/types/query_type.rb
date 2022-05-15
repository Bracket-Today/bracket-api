# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :tournament, Types::TournamentType, null: false do
      argument :id, ID, required: true
    end

    def tournament id:
      Tournament.find(id)
    end
  end
end
