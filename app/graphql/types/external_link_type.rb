# frozen_string_literal: true

module Types
  class ExternalLinkType < Types::BaseObject
    field :id, ID, null: false
    field :type, String, null: false
    field :url, String, null: false
  end
end
