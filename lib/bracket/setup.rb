# frozen_string_literal: true

class Preflight
  ENV_SUFFIX =  Rails.env.development? ? 'dev' : Rails.env
  EMAIL_SUFFIX = 'bracket.api.' + ENV_SUFFIX
  DEVELOPERS = [
    'jared.morgan',
    # 'mike.morgan',
    # 'gary.michaud',
  ]

  DEVELOPER_EMAILS = DEVELOPERS.map do |name|
    "#{name}+#{EMAIL_SUFFIX}@preflighttech.com"
  end
end

require 'pti_base/enum_adapter'

require 'bracket/development_mail_interceptor'
Rails.application.reloader.to_prepare do
  ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor)
end

require 'pti_issues'
PtiIssues.setup do |config|
  config.url = 'https://preflighttech.com/api/1/issues'
  config.access_token = Rails.application.credentials.pti[:key]
end
