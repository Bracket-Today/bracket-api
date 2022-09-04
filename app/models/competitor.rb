# frozen_string_literal: true

class Competitor < ApplicationRecord
  scope :ordered, -> { order :seed, :id }

  belongs_to :entity
  belongs_to :tournament
  has_many :votes

  delegate :name, to: :entity

  after_destroy :destroy_empty_entity

  def winner_score round:
    contest = self.tournament.contests.
      find_by(round: round, winner_id: self.id)

    if contest.nil?
      nil
    elsif contest.upper == self
      [contest.upper_vote_count, contest.lower_vote_count]
    else
      [contest.lower_vote_count, contest.upper_vote_count]
    end
  end

  private

  # Called after destroy. If the entity has no competitors, destroy the  entity.
  def destroy_empty_entity
    Rails.logger.info 'here'
    Rails.logger.info self.entity.competitors.empty?

    self.entity.destroy if self.entity.competitors.empty?
  end
end
