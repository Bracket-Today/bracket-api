# frozen_string_literal: true

module Types
  class AdminMutationType < Types::BaseObject
    field :schedule_featured_tournament,
      mutation: Mutations::Tournaments::ScheduleFeaturedTournament
  end
end
