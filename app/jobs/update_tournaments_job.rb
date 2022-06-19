# frozen_string_literal: true

class UpdateTournamentsJob < ApplicationJob
  queue_as :default

  def perform
    TournamentService::UpdateRounds.call
  end
end
