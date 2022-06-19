# frozen_string_literal: true

require 'clockwork'
require_relative './boot'
require_relative './environment'

module Clockwork
  every 10.minutes, 'UpdateTournamentsJob' do
    UpdateTournamentsJob.perform_later
  end
end
