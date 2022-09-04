# frozen_string_literal: true

module Mutations
  module Tournaments
    class DeleteTournament < Mutations::BaseMutation
      description <<-DESCRIPTION
        Delete the tournament and all it's competitors (including associated
        entities if only a competitor in this tournament).
      DESCRIPTION

      argument :id, ID, required: true, loads: Types::TournamentType,
        as: :tournament

      field :errors, [Types::UserError], null: false

      def resolve tournament:
        restrict_tournament_status! tournament

        destroy_resource :tournament, tournament
      end
    end
  end
end
