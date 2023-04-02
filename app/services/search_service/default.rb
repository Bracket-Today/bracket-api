# frozen_string_literal: true

module SearchService
  class Default
    include Elasticsearch::DSL
    include Service

    def initialize term:
      @term = term
    end

    def call
      term = @term

      definition = search do
        query do
          function_score do
            query do
              match :name do
                query term
              end
            end

            functions << {
              filter: { match: { typename: 'Tournament' } },
              weight: 2
            }
          end
        end
      end

      Elasticsearch::Model.search(
        definition,
        [Tournament, Entity]
      ).records.records
    end
  end
end
