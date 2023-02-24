# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExternalLink, type: :model do
  subject(:external_link) { FactoryBot.build(:external_link) }

  it { is_expected.to be_valid }

  describe 'scopes' do
    let!(:links) do
      FactoryBot.create_list(:external_link, 3)
    end

    describe '.ordered' do
      subject { ExternalLink.ordered }
      it { is_expected.to scope_as(links, [0,1,2]) }
    end
  end

  it { is_expected.to belong_to(:owner) }
  it { is_expected.to validate_presence_of(:type) }
  it { is_expected.to validate_presence_of(:url) }

  describe '#update_type' do
    context 'current type is not Other' do
      it 'does nothing' do
        external_link.type = 'YouTube'
        external_link.url = 'https://www.amazon.com/gp/product/ABC123/ref'
        external_link.save!
        expect(external_link.type).to eq('YouTube')
        expect(external_link.short_code).to be(nil)
      end
    end

    context 'Amazon URL' do
      it 'sets type to Amazon and sets short_code' do
        external_link.url = 'https://www.amazon.com/gp/product/ABC123/ref'
        external_link.save!
        expect(external_link.type).to eq('Amazon')
        expect(external_link.short_code).to eq('ABC123')
      end

      it 'sets type to Amazon and sets short_code' do
        external_link.url = 'https://www.amazon.com/Abc-123/dp/ABC123/ref=A'
        external_link.save!
        expect(external_link.type).to eq('Amazon')
        expect(external_link.short_code).to eq('ABC123')
      end
    end

    context 'YouTube URL' do
      it 'sets type to YouTube and sets short_code' do
        external_link.url = 'https://www.youtube.com/watch?v=123abc'
        external_link.save!
        expect(external_link.type).to eq('YouTube')
        expect(external_link.short_code).to eq('123abc')
      end

      context 'share link' do
        it 'sets type to YouTube and sets short_code' do
          external_link.url = 'https://youtu.be/123abc'
          external_link.save!
          expect(external_link.type).to eq('YouTube')
          expect(external_link.short_code).to eq('123abc')
        end
      end
    end

    context 'Image extension' do
      it 'sets type to Image' do
        external_link.url = 'https://example.com/test.JPG'
        external_link.save!
        expect(external_link.type).to eq('Image')
      end
    end

    context 'Video extension' do
      it 'sets type to Video' do
        external_link.url = 'https://example.com/test.Mov'
        external_link.save!
        expect(external_link.type).to eq('Video')
      end
    end
  end
end
