# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShortCode, type: :model do
  subject(:short_code) { FactoryBot.build(:short_code) }

  it { is_expected.to be_valid }

  it { is_expected.to belong_to(:resource) }

  it { is_expected.to validate_presence_of(:code) }

  describe '.resource' do
    let! :resources do
      [
        FactoryBot.create(:tournament),
        FactoryBot.create(:tournament),
      ]
    end

    it 'gets resource by code' do
      expect(ShortCode.resource(resources[0].short_code)).to eq(resources[0])
      expect(ShortCode.resource(resources[1].short_code)).to eq(resources[1])
      expect(ShortCode.resource(resources[0].short_code)).to eq(resources[0])
    end

    context 'type argument' do
      it 'gets resource, matching type' do
        expect(ShortCode.resource(resources[0].short_code)).to eq(resources[0])
        expect(ShortCode.resource(resources[0].short_code, type: 'Entity')).
          to be(nil)
      end
    end
  end
end
