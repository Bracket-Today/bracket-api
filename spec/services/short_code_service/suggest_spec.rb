# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShortCodeService::Suggest do
  subject(:service) { ShortCodeService::Suggest.new }

  describe '#call' do
    subject { service.call }

    it { is_expected.to_not match(/[-_\s]/) }

    describe 'length' do
      subject { service.call.length }
      it { is_expected.to be(6) }
    end

    describe 'check_method' do
      it 'calls check method' do
        expect { ShortCode.to_receive(:find_by_code).once.and_return(false) }
        service.call
      end
    end
  end
end
