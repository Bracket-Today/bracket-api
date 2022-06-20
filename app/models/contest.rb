# frozen_string_literal: true

class Contest < ApplicationRecord
  scope :ordered, -> { order :round, :sort }

  belongs_to :tournament
  belongs_to :upper, class_name: 'Competitor', required: false
  belongs_to :lower, class_name: 'Competitor', required: false
  belongs_to :winner, class_name: 'Competitor', required: false

  has_many :votes

  validates :round, :sort, presence: true

  # @return [Boolean]
  #   True if contest has all competitors and no winner.
  def active?
    return false unless self.tournament.current_round_by_time == self.round
    !!(self.upper && self.lower && !self.winner)
  end

  # @return [Contest]
  #   Get contest in which winner will participate, nil if final round.
  #
  # TODO Ensure this will work with partial rounds.
  def winner_contest
    tournament.contests.find_by(
      round: self.round + 1, sort: (self.sort.to_f / 2).floor
    )
  end

  # @param competitor [Competitor]
  # @return [Integer] Votes for competitor for this Contest.
  def vote_count competitor:
    votes.where(competitor_id: competitor.id).count
  end

  # @return [Integer] Votes for upper competitor for this Contest.
  def upper_vote_count
    vote_count(competitor: self.upper)
  end

  # @return [Integer] Votes for lower competitor for this Contest.
  def lower_vote_count
    vote_count(competitor: self.lower)
  end

  # @return [Competitor] Leader, based on votes, then seed, then id.
  def leader
    [upper, lower].compact.sort_by do |competitor|
      [-vote_count(competitor: competitor), competitor.seed, competitor.id]
    end.first
  end

  # Set winner and add winner competitor to next contest.
  #
  # @param winner [Competitor]
  def won! winner = nil
    winner ||= self.leader

    self.update! winner: winner
    upper_or_lower = (0 == self.sort % 2) ? 'upper' : 'lower'
    self.winner_contest.try(:update!, upper_or_lower => winner)
  end
end
