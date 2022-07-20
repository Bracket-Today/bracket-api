module Types
  class MutationType < Types::BaseObject
    field :create_competitor,
      mutation: Mutations::Competitors::CreateCompetitor

    field :create_tournament,
      mutation: Mutations::Tournaments::CreateTournament

    field :submit_vote, mutation: Mutations::Contests::SubmitVote
  end
end
