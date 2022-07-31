# frozen_string_literal: true

module Mutations
  module Tournaments
    class ScheduleFeaturedTournament < Mutations::BaseMutation
      argument :id, ID, required: true, loads: Types::TournamentType,
        as: :tournament

      field :tournament, Types::TournamentType, null: true
      field :errors, [Types::UserError], null: false

      def resolve tournament:
        attributes = {
          status: 'Pending',
          featured: true,
          start_at: Tournament.featured.maximum(:start_at).advance(days: 1),
        }

        update_resource :tournament, tournament, attributes
      end
    end
  end
end
