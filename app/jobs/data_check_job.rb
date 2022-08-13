# frozen_string_literal: true

class DataCheckJob < ApplicationJob
  def perform
    DataCheckService::TournamentSeeds.call
  end
end
