# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.build(:user) }

  it { is_expected.to be_valid }

  describe '.by_uuid' do
    let!(:existing) do
      [
        FactoryBot.create(:user, uuid: 'A'),
        FactoryBot.create(:user, uuid: 'B'),
      ]
    end

    context 'existing user with uuid' do
      subject { User.by_uuid('A') }

      it { is_expected.to eq(existing[0]) }

      it 'does not create a User' do
        expect { User.by_uuid('A') }.to_not change { User.count }
      end
    end

    context 'no existing user with uuid' do
      subject { User.by_uuid('C') }

      it { is_expected.to be_a(User) }

      it 'creates a User' do
        expect { User.by_uuid('C') }.to change { User.count }
      end
    end
  end
end
