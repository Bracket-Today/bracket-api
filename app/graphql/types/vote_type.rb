# frozen_string_literal: true

module Types
  class VoteType < Types::BaseObject
    field :id, ID, null: false
    field :contest_id, ID, null: false
    field :contest, Types::ContestType, null: false
  end
end
