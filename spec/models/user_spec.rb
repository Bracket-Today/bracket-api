# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.build(:user) }

  it { is_expected.to be_valid }

  describe '#login_code' do
    subject { user.login_code }

    context 'existing login_code' do
      before(:each) { user.login_code = 'abc12_' }
      it { is_expected.to eq('abc12_') }
    end

    context 'no existing login_code' do
      before(:each) { user.login_code = nil }
      it { is_expected.to_not eq('abc12_') }
      it { is_expected.to be_a(String) }
    end
  end

  describe '#generate_login_code' do
    it 'sets login_code with new code' do
      user.save!
      code = user.generate_login_code
      expect(User.find(user.id).login_code).to eq(code)
      expect(code).to be_a(String)
      expect(code.length).to eq(6)
      expect(code).to_not include('_')
      expect(code).to_not include('-')
      expect(code).to_not match(/\s/)
    end
  end

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
