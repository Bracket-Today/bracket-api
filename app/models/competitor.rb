# frozen_string_literal: true

class Competitor < ApplicationRecord
  scope :ordered, -> { order :seed, :id }
  scope :searchable, -> { joins(:tournament).merge(Tournament.searchable) }

  belongs_to :entity
  belongs_to :tournament
  has_many :votes

  delegate :name, to: :entity

  after_destroy :destroy_empty_entity

  def winner_score round:
    contest = self.tournament.contests.
      find_by(round: round, winner_id: self.id)

    if contest.nil? || contest.lower.nil?
      nil
    elsif contest.upper == self
      [contest.upper_vote_count, contest.lower_vote_count]
    else
      [contest.lower_vote_count, contest.upper_vote_count]
    end
  end

  # @return [Boolean]
  #   Is the competitor's entity shared with any other competitor? If so,
  #   special considerations may be needed when updating entity attributes.
  def shared_entity?
    self.entity.competitors.where.not(id: self.id).any?
  end

  private

  # Called after destroy. If the entity has no competitors, destroy the  entity.
  def destroy_empty_entity
    self.entity.destroy if self.entity.competitors.empty?
  end
end
