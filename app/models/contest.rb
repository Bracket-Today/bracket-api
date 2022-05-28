# frozen_string_literal: true

class Contest < ApplicationRecord
  scope :ordered, -> { order :round, :sort }

  belongs_to :tournament
  belongs_to :upper, class_name: 'Competitor', required: false
  belongs_to :lower, class_name: 'Competitor', required: false
  belongs_to :winner, class_name: 'Competitor', required: false

  validates :round, :sort, presence: true

  # @return [Contest]
  #   Get contest in which winner will participate, nil if final round.
  #
  # TODO Ensure this will work with partial rounds.
  def winner_contest
    tournament.contests.find_by(
      round: self.round + 1, sort: (self.sort.to_f / 2).floor
    )
  end

  # Set winner and add winner competitor to next contest.
  #
  # @param winner [Competitor]
  def won! winner
    self.update! winner: winner
    upper_or_lower = (0 == self.sort % 2) ? 'upper' : 'lower'
    self.winner_contest.try(:update!, upper_or_lower => winner)
  end
end
