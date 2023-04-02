# frozen_string_literal: true

module CompetitorService
  class Create
    include Service

    def initialize tournament:, entity: nil, name: nil, annotation: nil,
        entity_annotation: nil, seed: nil, urls: []

      @tournament, @entity, @name = tournament, entity, name
      @annotation, @entity_annotation = annotation, entity_annotation
      @seed = seed
      @urls = urls
    end

    def call
      if :match == @entity
        @entity = Entity.find_by(name: @name.strip)
      end

      if @entity.nil?
        @entity = Entity.new(name: @name.strip)
      end

      if @entity_annotation.present?
        if @entity.annotation.blank?
          @entity.annotation = @entity_annotation.strip
        elsif @annotation.blank?
          @annotation = @entity_annotation.strip
        end
      end

      @entity.save!

      @urls.each do |url|
        @entity.external_links.where(url: url).first_or_create
      end

      competitor = @tournament.competitors.new(entity: @entity)
      competitor.annotation = @annotation.strip if @annotation.present?
      competitor.seed = @seed || (@tournament.competitors.count + 1)

      return success(competitor: competitor)
    end
  end
end
