# frozen_string_literal: true

module SearchService
  class Rebuild
    include Service

    def call
      Entity.__elasticsearch__.create_index! force: true
      Entity.__elasticsearch__.import
      Entity.__elasticsearch__.refresh_index!
      Tournament.__elasticsearch__.create_index! force: true
      Tournament.__elasticsearch__.import
      Tournament.__elasticsearch__.refresh_index!
    end
  end
end
