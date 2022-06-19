# frozen_string_literal: true

Rails.application.routes.draw do
  scope 'api/1' do
    get 'health', to: 'health#index'
    post 'graphql', to: 'graphql#execute'
  end
end
