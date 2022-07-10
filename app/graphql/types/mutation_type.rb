module Types
  class MutationType < Types::BaseObject
    field :create_tournament,
      mutation: Mutations::Tournaments::CreateTournament

    field :submit_vote, mutation: Mutations::Contests::SubmitVote
  end
end
