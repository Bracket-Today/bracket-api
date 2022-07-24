# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tournaments, foreign_key: 'owner_id'
  has_many :votes

  def login_code
    super || generate_login_code
  end

  # Generate a unique 6-character code and save as login_code.
  # @return [String]
  def generate_login_code
    code = nil
    while code.nil?
      try_code = SecureRandom.urlsafe_base64[0..5]
      next if try_code =~ /\W/
      next if try_code =~ /_/
      next if User.find_by_login_code(try_code)
      code = try_code
    end

    if self.persisted?
      update_column(:login_code, code)
    else
      self.login_code = code
    end

    code
  end

  # Determine whether the user should vote in a given context, meaning that
  # there is a contest within the contest on which this user can vote but has
  # not. If given no arguments, checks against all contests in all active
  # tournaments.
  #
  # @param tournament [Tournament]
  #   A Tournament to check (ignored if contest is specified.
  # @param contest [Contest]
  #   A specific Contest to check.
  # @return [Boolean]
  def should_vote? tournament: nil, contest: nil
    if contest
      contest.active? && contest.votes.where(user: self).empty?
    elsif tournament
      tournament.active? && tournament.contests.any? do |contest|
        self.should_vote?(contest: contest)
      end
    else
      Tournament.active.any? do |tournament|
        self.should_vote? tournament: tournament
      end
    end
  end

  # @return [Tournament, nil]
  #   Tournament, if any, with open contest(s) where user has not voted.
  def next_tournament_to_vote
    Tournament.active.detect do |tournament|
      self.should_vote? tournament: tournament
    end
  end

  def self.by_uuid uuid
    if uuid.present?
      User.where(uuid: uuid).first_or_create!
    else
      nil
    end
  end
end
