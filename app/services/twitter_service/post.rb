# frozen_string_literal: true

module TwitterService
  class Post
    include Service

    def initialize message, force: false
      @message, @force = message, force
    end

    def call
      return # Disabled due to auth error
      if @force || Rails.env.production?
        credentials = Rails.application.credentials

        client = Twitter::REST::Client.new do |config|
          config.consumer_key = credentials.dig(:twitter, :key)
          config.consumer_secret = credentials.dig(:twitter, :key_secret)
          config.access_token = credentials.dig(:twitter, :user_access_token)
          config.access_token_secret =
            credentials.dig(:twitter, :user_token_secret)
        end

        client.update(@message)
      else
        Rails.logger.info "TWITTER: #{@message}"
      end
    end
  end
end
