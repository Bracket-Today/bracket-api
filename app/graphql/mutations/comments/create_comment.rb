# frozen_string_literal: true

module Mutations
  module Comments
    class CreateComment < Mutations::BaseMutation
      argument :tournament_id, ID, required: true, loads: Types::TournamentType,
        as: :tournament
      argument :parent_id, ID, required: false
      argument :body, String, required: true

      field :comment, Types::CommentType, null: true
      field :errors, [Types::UserError], null: false

      def resolve(**attributes)
        unless current_user.confirmed?
          return(
            { errors: { message: 'You must register your email', path: '' } }
          )
        end

        attributes = attributes.merge(user: context[:current_user])
        create_resource :comment, Comment.new(attributes)
      end
    end
  end
end
