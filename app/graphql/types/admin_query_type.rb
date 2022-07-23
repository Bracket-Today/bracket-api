# frozen_string_literal: true

module Types
  class AdminQueryType < Types::BaseObject
    field :tournaments, [Types::TournamentType], null: false

    def tournaments
      Tournament.all
    end
  end
end
