# frozen_string_literal: true

class UpdateTournamentsJob < ApplicationJob
  def perform
    TournamentService::UpdateRounds.call
  end
end
