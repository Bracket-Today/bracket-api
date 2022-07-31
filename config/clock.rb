# frozen_string_literal: true

require 'clockwork'
require_relative './boot'
require_relative './environment'

module Clockwork
  error_handler do |error|
    PtiIssues.handle_exception exception: exception
  end

  every 10.minutes, 'UpdateTournamentsJob' do
    UpdateTournamentsJob.perform_later
  end

  every 1.day, 'CheckFeaturedScheduleJob', at: '20:00' do
    CheckFeaturedScheduleJob.perform_later
  end
end
