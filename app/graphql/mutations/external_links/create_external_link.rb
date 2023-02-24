# frozen_string_literal: true

module Mutations
  module ExternalLinks
    class CreateExternalLink < Mutations::BaseMutation
      argument :owner_type, String, required: true
      argument :owner_id, ID, required: true
      argument :type, String, required: true
      argument :url, String, required: true

      field :external_link, Types::CommentType, null: true
      field :errors, [Types::UserError], null: false

      def resolve(**attributes)
        create_resource :external_link, ExternalLink.new(attributes)
      end
    end
  end
end
