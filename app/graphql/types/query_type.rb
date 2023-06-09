# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field_class GraphqlDevise::Types::BaseField

    field :current_user, Types::UserType, null: true

    def current_user
      context[:current_user]
    end

    field :announcements, [Types::AnnouncementType], null: false

    def announcements
      Announcement.display_subset
    end

    field :entities, [Types::EntityType], null: false do
      argument :term, String, required: true
      argument :limit, Int, required: false
    end

    def entities term:, limit: 100
      Entity.where(Entity[:name].matches("%#{term}%")).limit(limit)
    end

    field :entity, Types::EntityType, null: true do
      argument :id, ID, required: true
    end

    def entity id:
      ShortCode.resource(id, type: 'Entity') || Entity.find_by_id(id)
    end

    field :login_code, Types::LoginCodeType, null: true do
      argument :code, String, required: true
    end

    def login_code code:
      User.uuid.find_by_login_code(code)
    end

    field :search, [Types::SearchResultUnion], null: false do
      argument :term, String, required: true
    end

    def search term:
      SearchService::Default.call(term: term)
    end

    field :tournaments, [Types::TournamentType], null: false do
      argument :scopes, [String], required: false
    end

    field :votes, [Types::VoteType], null: false

    def tournaments scopes: []
      relation = Tournament.all

      if scopes.include?('votable')
        relation = relation.visible.active.select do |tournament|
          context[:current_user].should_vote? tournament: tournament
        end
      elsif scopes.include?('active')
        relation = relation.active
      elsif scopes.include?('activeAndRecent')
        relation = relation.active_and_recent
      elsif scopes.include?('seeding')
        relation = relation.seeding
      elsif scopes.include?('upcoming')
        relation = relation.upcoming
      end

      if scopes.include?('visible')
        relation = relation.visible
      end

      relation
    end

    field :tournament, Types::TournamentType, null: true do
      argument :id, ID, required: true
    end

    def tournament id:
      ShortCode.resource(id, type: 'Tournament') || Tournament.find_by_id(id)
    end

    field :videos, [Types::VideoType], null: false

    def videos
      Video.display_subset
    end
  end
end
