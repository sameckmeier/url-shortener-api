require 'rails_helper'

describe Client do
  it 'has a valid factory' do
    expect(build(:client)).to be_valid
  end

  it 'validates secret presence' do
    expect(build(:client, secret: nil)).not_to be_valid
  end
end
