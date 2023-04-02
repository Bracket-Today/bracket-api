# frozen_string_literal: true

class Types::SearchResultUnion < Types::BaseUnion
  possible_types Types::TournamentType, Types::EntityType

  def self.resolve_type object, *args
    if object.is_a? Tournament
      Types::TournamentType
    elsif object.is_a? Entity
      Types::EntityType
    end
  end
end
