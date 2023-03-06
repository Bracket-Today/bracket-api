module Types
  class MutationType < Types::BaseObject
    field_class GraphqlDevise::Types::BaseField

    field :create_competitor,
      mutation: Mutations::Competitors::CreateCompetitor
    field :create_competitors,
      mutation: Mutations::Competitors::CreateCompetitors
    field :remove_competitor,
      mutation: Mutations::Competitors::RemoveCompetitor
    field :update_competitor,
      mutation: Mutations::Competitors::UpdateCompetitor

    field :create_comment,
      mutation: Mutations::Comments::CreateComment

    field :create_tournament,
      mutation: Mutations::Tournaments::CreateTournament
    field :update_tournament_seeds,
      mutation: Mutations::Tournaments::UpdateTournamentSeeds
    field :delete_tournament,
      mutation: Mutations::Tournaments::DeleteTournament
    field :random_tournament_seeds,
      mutation: Mutations::Tournaments::RandomTournamentSeeds
    field :schedule_tournament,
      mutation: Mutations::Tournaments::ScheduleTournament
    field :update_tournament,
      mutation: Mutations::Tournaments::UpdateTournament
    field :update_tournament_visibility,
      mutation: Mutations::Tournaments::UpdateTournamentVisibility
    field :clone_tournament,
      mutation: Mutations::Tournaments::CloneTournament

    field :submit_vote, mutation: Mutations::Contests::SubmitVote
    field :clear_vote, mutation: Mutations::Contests::ClearVote

    field :register_user, mutation: Mutations::Users::RegisterUser
    field :update_current_user, mutation: Mutations::Users::UpdateCurrentUser
  end
end
