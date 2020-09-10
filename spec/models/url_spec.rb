require 'rails_helper'

describe Url do
  it 'has a valid factory' do
    expect(build(:url)).to be_valid
  end

  it 'validates original presence' do
    expect(build(:url, original: nil)).not_to be_valid
  end

  it 'validates shortened presence' do
    expect(build(:url, shortened: nil)).not_to be_valid
  end

  it 'validates client association' do
    expect(build(:url, client: nil)).not_to be_valid
  end
end
