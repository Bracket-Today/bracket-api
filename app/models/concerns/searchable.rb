# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    if Rails.application.config.search_enabled
      include Elasticsearch::Model::Callbacks
    end
  end

  def as_indexed_json options={}
    { typename: self.class.name }.
      merge(self.as_json(options.merge(root: false)))
  end
end
