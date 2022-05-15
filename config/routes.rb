# frozen_string_literal: true

Rails.application.routes.draw do
  post '/api/1/graphql', to: 'graphql#execute'
end
