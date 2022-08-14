# frozen_string_literal: true

class Competitor < ApplicationRecord
  scope :ordered, -> { order :seed, :id }

  belongs_to :entity
  belongs_to :tournament
  has_many :votes

  delegate :name, to: :entity

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
end
