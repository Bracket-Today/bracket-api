# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entity, type: :model do
  subject(:entity) { FactoryBot.build(:entity) }

  it { is_expected.to be_valid }

  describe 'scopes' do
    let!(:entities) { FactoryBot.create_list(:entity, 3) }

    describe '.ordered' do
      subject { Entity.ordered }
      it { is_expected.to scope_as(entities, [0,1,2]) }
    end
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :path }

  it { is_expected.to have_many :competitors }
  it { is_expected.to have_many :external_links }

  describe '#set_path' do
    subject { entity.path }

    before(:each) do
      entity.name = "Test a&b"
      entity.set_path
    end

    it { is_expected.to eq('/misc/test-ab') }

    context 'prefix given' do
      before(:each) { entity.set_path prefix: '/test/path' }

      it { is_expected.to eq('/test/path/test-ab') }
    end
  end
end
