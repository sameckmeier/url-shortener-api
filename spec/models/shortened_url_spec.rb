require 'rails_helper'

describe ShortenedUrl do
  it 'has a valid factory' do
    expect(build(:shortened_url)).to be_valid
  end

  it 'validates sequence presence' do
    expect(build(:shortened_url, sequence: nil)).not_to be_valid
  end

  describe :current do
    let!(:shortened_url) { create(:shortened_url) }

    it 'returns first ShortenedUrl' do
      expect(ShortenedUrl.current).to eq(shortened_url)
    end
  end

  describe :increment_sequence do
    subject(:shortened_url) { create(:shortened_url, sequence: initial_char).increment_sequence }

    context 'when last char is not the final char' do
      let(:initial_char) { 'a' }

      it 'increments the final char' do
        expect(shortened_url.sequence).to eq('b')
      end
    end

    context 'when last char is the final char' do
      context 'and it is in the first position' do
        let(:initial_char) { '9' }

        it 'resets it to the initial char and appends a char to the sequence' do
          expect(shortened_url.sequence).to eq('aa')
        end
      end

      context 'and the char previous to it is not the final char' do
        let(:initial_char) { 'a9' }

        it 'resets it to the initial char and increments the previous char' do
          expect(shortened_url.sequence).to eq('ba')
        end
      end

      context 'and the char previous to it is the final char' do
        let(:initial_char) { '99' }

        it 'resets it to the initial char and increments the previous char' do
          expect(shortened_url.sequence).to eq('aaa')
        end
      end
    end
  end
end
