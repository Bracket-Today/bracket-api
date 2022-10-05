# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Announcement, type: :model do
  subject(:announcement) { FactoryBot.build(:announcement) }

  it { is_expected.to be_valid }

  describe 'scopes' do
    let!(:announcements) do
      [
        FactoryBot.create(:announcement),
        FactoryBot.create(:announcement, start_at: 10.minutes.ago),
        FactoryBot.create(
          :announcement, start_at: 10.minutes.ago, end_at: 10.minutes.from_now,
          always_show: true
        ),
        FactoryBot.create(
          :announcement, start_at: 10.minutes.ago, end_at: 5.minutes.ago
        ),
        FactoryBot.create(
          :announcement,
          start_at: 5.minutes.from_now,
          end_at: 10.minutes.from_now,
          always_show: true
        ),
      ]
    end

    describe '.ordered' do
      subject { Announcement.ordered }
      it { is_expected.to scope_as(announcements, [0,1,2,3,4]) }
    end

    describe '.active' do
      subject { Announcement.active.ordered }
      it { is_expected.to scope_as(announcements, [1,2]) }
    end

    describe '.always_show' do
      subject { Announcement.always_show.ordered }
      it { is_expected.to scope_as(announcements, [2,4]) }
    end

    describe '.sometimes_show' do
      subject { Announcement.sometimes_show.ordered }
      it { is_expected.to scope_as(announcements, [0,1,3]) }
    end

    describe '.display_subset' do
      subject { Announcement.display_subset }
      it { is_expected.to scope_as(announcements, [2,1]) }
    end
  end

  it { is_expected.to validate_presence_of :subject }
end
