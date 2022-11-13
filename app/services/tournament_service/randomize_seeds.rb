# frozen_string_literal: true

module TournamentService
  class RandomizeSeeds
    include Service

    def initialize tournament:, mild: false
      @tournament, @mild = tournament, mild
    end

    def call
      if @mild
        competitor_sorts = @tournament.competitors.to_a.map do |competitor|
          {
            competitor: competitor,
            sort: competitor.seed + rand(-2.5..2.5),
          }
        end

        competitor_sorts.sort_by! { |data| data[:sort] }

        competitor_sorts.each_with_index do |data, index|
          data[:competitor].update!(seed: index + 1)
        end
      else
        @tournament.competitors.shuffle.each_with_index do |competitor, index|
          competitor.update!(seed: index + 1)
        end
      end
    end
  end
end
