require 'rails_helper'

describe ShortenedUrl do
  it 'has a valid factory' do
    expect(build(:shortened_url)).to be_valid
  end

  it 'validates sequence presence' do
    expect(build(:shortened_url, sequence: nil)).not_to be_valid
  end

  describe :current do
    pending "TODO"
  end

  describe :increment_sequence do
    pending "TODO"
  end
end
