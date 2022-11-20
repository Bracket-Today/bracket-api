# frozen_string_literal: true

module Mutations
  module Tournaments
    class UpdateTournament < Mutations::BaseMutation
      argument :id, ID, required: true, loads: Types::TournamentType,
        as: :tournament
      argument :name, String, required: true
      argument :notes, String, required: false

      field :tournament, Types::TournamentType, null: true
      field :errors, [Types::UserError], null: false

      def resolve(tournament:, **attributes)
        restrict_tournament_status! tournament

        update_resource :tournament, tournament, attributes
      end
    end
  end
end
