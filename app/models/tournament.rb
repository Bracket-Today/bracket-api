# frozen_string_literal: true

class Tournament < ApplicationRecord
  include HasShortCode

  class ContestsExistError < StandardError; end

  scope :ready_to_activate, -> {
    where(status: 'Pending').where(Tournament[:start_at].lteq(Time.now))
  }

  scope :active, -> { where status: 'Active' }
  scope :active_and_recent, -> {
    where(
      Tournament[:status].eq('Active').or(
        Tournament[:status].eq('Closed').and(
          Tournament[:start_at].gteq(15.days.ago)
        )
      )
    ).order(start_at: :desc, id: :desc)
  }

  scope :seeds_required, -> { where status: ['Pending', 'Active', 'Closed'] }

  scope :featured, -> { where featured: true }

  belongs_to :owner, class_name: 'User', required: false

  has_many :competitors, dependent: :destroy
  has_many :contests
  has_many :votes, through: :contests

  validates :name, :round_duration, :status, presence: true

  # @return [Boolean] Is status active?
  def active?
    'Active' == self.status
  end

  # @return [String] Path to bracket.
  def bracket_path
    "/bracket/#{short_code}/#{slug}"
  end

  # Get expected current round number based on start_at and duration.
  #
  # @return [Integer]
  def current_round_by_time
    if self.start_at
      [
        [((Time.now - self.start_at) / self.round_duration + 1).floor, 0].max,
        self.contests.maximum(:round).to_i
      ].min
    else
      0
    end
  end

  def rounds
    unique_rounds = self.contests.group(:round).count.length

    retval = Hash.new do |hsh, number|
      end_at = self.start_at + self.round_duration * number

      hsh[number] = {
        number: number,
        contests: [],
        multiplier: 2 ** (unique_rounds - number),
        seconds_remaining: [end_at - Time.now, 0].max,
      }
    end

    self.contests.ordered.each do |contest|
      retval[contest.round][:contests] << contest
    end

    retval.values
  end

  def round number: nil
    number ||= current_round_by_time
    rounds[number - 1] || rounds.last
  end

  def winner
    contests.order(:round).last.try(:winner)
  end

  def votes_count
    self.votes.count
  end

  def voters_count
    self.votes.group(:user_id).count.keys.compact.length
  end

  def contests_count
    self.contests.count
  end


  # Ensure competitor seeds are 1..competitors.length. Orders competitors and
  # applies new seeds based on order. Intended to be called when tournament
  # activated.
  def reseed!
    seed = 1
    (
      self.competitors.where.not(seed: nil).ordered +
      self.competitors.where(seed: nil).ordered
    ).each do |competitor|
      competitor.update(seed: seed)
      seed += 1
    end
  end

  # Create all contests (for all rounds) with round 1 competitors based on
  # seeds. Note, upper and lower refer to physical placement on the bracket,
  # so, at least in the first round, upper is always a smaller number than
  # lower.
  #
  # @raises [Tournament::ContestsExistError] If any contests exist.
  def create_contests!
    raise(ContestsExistError, self.id) if self.contests.any?

    first_round_contests = first_round_preview
    first_round_contests.each(&:save!)
    _fraction, full_rounds = Math.frexp(first_round_contests.length)

    2.upto(full_rounds) do |round|
      (2 ** (full_rounds - round)).times do |sort|
        self.contests.create!(round: round, sort: sort)
      end
    end

    self.contests.where(round: 1).each do |contest|
      contest.won! if contest.lower.nil? && contest.upper
    end
  end

  # Build first round contests without saving, to allow previewing first round.
  # Also called by create_contests! when ready.
  #
  # @return [Array<Contest>]
  def first_round_preview
    contests = []
    seeded_competitors = self.competitors.ordered

    _fraction, full_rounds = Math.frexp(seeded_competitors.length - 1)
    full_round_count = 2 ** full_rounds

    Tournament.round_indexes(full_rounds).each_with_index do |indexes, sort|
      contest = self.contests.new(
        round: 1,
        sort: sort,
      )

      if indexes[0] < full_round_count
        contest.upper = seeded_competitors[indexes[0]]
      end

      if indexes[1] < full_round_count
        contest.lower = seeded_competitors[indexes[1]]
      end

      contests << contest if contest.upper
    end

    contests
  end

  def summary_contests
    self.contests.where(round: current_round_by_time).
      where.not(Contest[:lower_id].eq(nil)).
      limit(2)
  end

  def self.round_indexes total_rounds
    contests = [[0, 1]]

    (total_rounds - 1).times do
      new_contests = []
      round_competitors = contests.length * 4

      contests.each_with_index do |contest, index|
        upper, lower = *contest

        if 2 == index % 4 # Not sure if this is generally correct
          new_contests << [round_competitors - lower - 1, lower]
          new_contests << [upper, round_competitors - upper - 1]
        else
          new_contests << [upper, round_competitors - upper - 1]
          new_contests << [round_competitors - lower - 1, lower]
        end
      end

      contests = new_contests
    end

    contests.each do |contest|
      contest.sort!
    end

    contests
  end
end
