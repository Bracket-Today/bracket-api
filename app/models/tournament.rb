# frozen_string_literal: true

class Tournament < ApplicationRecord
  class ContestsExistError < StandardError; end

  scope :ready_to_activate, -> {
    where(status: 'Pending').where(Tournament[:start_at].lteq(Time.now))
  }

  scope :active, -> { where status: 'Active' }

  has_many :competitors
  has_many :contests

  validates :name, :round_duration, :start_at, :status, presence: true

  # Get expected current round number based on start_at and duration.
  #
  # Note that this # doesn't care if the returned value exceeds the total
  # rounds because it's not anticipated that this method would be used once
  # the Tournament is closed.
  #
  # @return [Integer]
  def current_round_by_time
    [((Time.now - self.start_at) / self.round_duration + 1).floor, 0].max
  end

  def rounds
    unique_rounds = self.contests.count(:round)

    retval = Hash.new do |hsh, number|
      hsh[number] = {
        number: number,
        contests: [],
        multiplier: 2 ** (unique_rounds - number),
      }
    end

    self.contests.ordered.each do |contest|
      retval[contest.round][:contests] << contest
    end

    retval.values
  end

  def round number
    rounds[number - 1]
  end

  # Create all contests (for all rounds) with round 1 competitors based on
  # seeds. Note, upper and lower refer to physical placement on the bracket,
  # so, at least in the first round, upper is always a smaller number than
  # lower.
  #
  # @raises [Tournament::ContestsExistError] If any contests exist.
  def create_contests!
    raise(ContestsExistError, self.id) if self.contests.any?

    seeded_competitors = self.competitors.ordered

    _fraction, exponent = Math.frexp(seeded_competitors.length)
    full_rounds = exponent - 1

    full_round_count = 2 ** full_rounds
    extra_contests = seeded_competitors.count - full_round_count

    # Partial round
    extra_contests.times do |contest_num|
      upper_index = full_round_count - (extra_contests - contest_num)
      lower_index = full_round_count + (extra_contests - contest_num) - 1

      self.contests.create!(
        round: 0,
        sort: contest_num,
        upper: seeded_competitors[upper_index],
        lower: seeded_competitors[lower_index],
      )
    end

    Tournament.round_indexes(full_rounds).each_with_index do |indexes, sort|
      contest = self.contests.new(
        round: 1,
        sort: sort,
      )

      if indexes[0] < full_round_count - extra_contests
        contest.upper = seeded_competitors[indexes[0]]
      end

      if indexes[1] < full_round_count - extra_contests
        contest.lower = seeded_competitors[indexes[1]]
      end

      contest.save!
    end

    2.upto(full_rounds) do |round|
      (2 ** (full_rounds - round)).times do |sort|
        self.contests.create!(round: round, sort: sort)
      end
    end
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
