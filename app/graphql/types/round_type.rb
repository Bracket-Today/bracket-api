# frozen_string_literal: true

module Types
  class RoundType < Types::BaseObject
    field :number, Int, null: false
    field :multiplier, Int, null: false
    field :seconds_remaining, Int, null: false
    field :contests, [Types::ContestType], null: false
  end
end
