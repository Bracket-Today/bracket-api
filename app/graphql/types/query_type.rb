# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :current_user, Types::UserType, null: false

    def current_user
      context[:current_user]
    end

    field :entities, [Types::EntityType], null: false do
      argument :term, String, required: true
      argument :limit, Int, required: false
    end

    def entities term:, limit: 100
      Entity.where(Entity[:name].matches("%#{term}%")).limit(limit)
    end

    field :login_code, Types::LoginCodeType, null: true do
      argument :code, String, required: true
    end

    def login_code code:
      User.find_by_login_code(code)
    end

    field :tournaments, [Types::TournamentType], null: false do
      argument :scopes, [String], required: false
    end

    def tournaments scopes: []
      relation = Tournament.all

      if scopes.include?('votable')
        relation = relation.active.select do |tournament|
          context[:current_user].should_vote? tournament: tournament
        end
      elsif scopes.include?('active')
        relation = relation.active
      elsif scopes.include?('activeAndRecent')
        relation = relation.active_and_recent
      end

      relation
    end

    field :tournament, Types::TournamentType, null: false do
      argument :id, ID, required: true
    end

    def tournament id:
      Tournament.find(id)
    end
  end
end
