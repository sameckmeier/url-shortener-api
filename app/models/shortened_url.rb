class ShortenedUrl < ApplicationRecord
  validates :sequence, presence: true

  class << self
    alias current first
  end

  def increment_sequence; end
end
