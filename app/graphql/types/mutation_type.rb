module Types
  class MutationType < Types::BaseObject
    field :create_competitor,
      mutation: Mutations::Competitors::CreateCompetitor
    field :remove_competitor,
      mutation: Mutations::Competitors::RemoveCompetitor

    field :create_tournament,
      mutation: Mutations::Tournaments::CreateTournament
    field :update_tournament_seeds,
      mutation: Mutations::Tournaments::UpdateTournamentSeeds
    field :random_tournament_seeds,
      mutation: Mutations::Tournaments::RandomTournamentSeeds
    field :update_tournament_visibility,
      mutation: Mutations::Tournaments::UpdateTournamentVisibility

    field :submit_vote, mutation: Mutations::Contests::SubmitVote
  end
end
