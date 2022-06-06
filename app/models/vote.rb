# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :contest
  belongs_to :competitor
  belongs_to :user

  validates :user_id, uniqueness: { scope: :contest_id }
  validate :competitor_in_contest
  validate :check_active_contest

  private

  def check_active_contest
    if self.contest && !self.contest.active?
      errors.add(:contest, 'must be active')
    end
  end

  def competitor_in_contest
    if self.contest && self.competitor.try(:id)
      unless [contest.upper_id, contest.lower_id].include?(self.competitor.id)
        errors.add(:competitor, 'must be in contest')
      end
    end
  end
end
