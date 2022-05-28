# frozen_string_literal: true

module TournamentService
  class LoadJson
    include Service

    SAMPLES_PATH = Rails.application.root.join('db', 'samples.json')

    def initialize path: SAMPLES_PATH, truncate: true
      @path, @truncate = path, truncate
    end

    def call
      if @truncate
        Contest.delete_all
        Tournament.delete_all
      end

      JSON.load(File.read(@path)).each do |tournament_data|
        tournament = Tournament.create!(
          name: tournament_data['name'],
          start_at: tournament_data['start_at'] || Time.now
        )

        tournament_data['entries'].each_with_index do |entity_data, seed|
          if entity_data.is_a?(String)
            name = entity_data
            slug = entity_data.downcase.gsub(/\W/, '').gsub(/\s+/, '-')
          else
            name = entity_data['name']
            slug = entity_data['slug']
          end

          path = "#{tournament_data['prefix']}/#{slug}"

          entity = Entity.where(path: path).first || Entity.new
          entity.name = name
          entity.path = path

          entity.save!

          tournament.competitors.create!(
            entity: entity,
            seed: seed + 1
          )
        end

        tournament.create_contests!
      end
    end
  end
end
