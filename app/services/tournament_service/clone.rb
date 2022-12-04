# frozen_string_literal: true

module TournamentService
  class Clone
    include Service

    def initialize tournament:, owner:
      @tournament = tournament
      @owner = owner
    end

    def call
      clone = Tournament.create!(
        name: @tournament.name,
        based_on: @tournament,
        owner: @owner,
      )

      @tournament.competitors.each do |competitor|
        clone.competitors.create!(
          entity: competitor.entity,
          seed: competitor.seed,
          annotation: competitor.annotation,
        )
      end

      return success(tournament: clone, errors: [])
    end
  end
end
