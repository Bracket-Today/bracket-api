# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tournament, type: :model do
  subject(:tournament) { FactoryBot.build(:tournament) }

  it { is_expected.to be_valid }

  describe 'scopes' do
    let!(:tournaments) { FactoryBot.create_list(:tournament, 3) }

    describe '.ordered' do
      subject { Tournament.ordered }
      it { is_expected.to scope_as(tournaments, [0,1,2]) }
    end
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :round_duration }
  it { is_expected.to validate_presence_of :start_at }

  it { is_expected.to have_many :competitors }
end
