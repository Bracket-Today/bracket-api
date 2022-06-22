# frozen_string_literal: true

require 'pti_base/enum_adapter'

require 'pti_issues'
PtiIssues.setup do |config|
  config.url = 'https://preflighttech.com/api/1/issues'
  config.access_token = Rails.application.credentials.pti[:key]
end
