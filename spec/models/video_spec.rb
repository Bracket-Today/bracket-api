# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Video, type: :model do
  subject(:video) { FactoryBot.build(:video) }

  it { is_expected.to be_valid }

  describe 'scopes' do
    let!(:videos) do
      [
        FactoryBot.create(:video),
        FactoryBot.create(:video, start_at: 10.minutes.ago),
        FactoryBot.create(
          :video, start_at: 10.minutes.ago, end_at: 10.minutes.from_now,
          always_show: true
        ),
        FactoryBot.create(
          :video, start_at: 10.minutes.ago, end_at: 5.minutes.ago
        ),
        FactoryBot.create(
          :video,
          start_at: 5.minutes.from_now,
          end_at: 10.minutes.from_now,
          always_show: true
        ),
      ]
    end

    describe '.ordered' do
      subject { Video.ordered }
      it { is_expected.to scope_as(videos, [0,1,2,3,4]) }
    end

    describe '.active' do
      subject { Video.active.ordered }
      it { is_expected.to scope_as(videos, [1,2]) }
    end

    describe '.always_show' do
      subject { Video.always_show.ordered }
      it { is_expected.to scope_as(videos, [2,4]) }
    end

    describe '.sometimes_show' do
      subject { Video.sometimes_show.ordered }
      it { is_expected.to scope_as(videos, [0,1,3]) }
    end

    describe '.display_subset' do
      subject { Video.display_subset }
      it { is_expected.to scope_as(videos, [2,1]) }
    end
  end

  it { is_expected.to validate_presence_of :subject }
  it { is_expected.to validate_presence_of :youtube_id }
end
