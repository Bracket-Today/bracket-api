# frozen_string_literal: true

require 'faraday_middleware/aws_sigv4'

Rails.application.config.search_enabled =
  Rails.env.production? || 'enabled' == ENV['SEARCH']

config = Rails.application.credentials.elasticsearch || {}
options = config.merge(log: true)

Elasticsearch::Model.client = Elasticsearch::Client.new(**options) do |connect|
  connect.request(:aws_sigv4, **config)
end
