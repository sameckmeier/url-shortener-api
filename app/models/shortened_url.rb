class ShortenedUrl < ApplicationRecord
  INITIAL_SEQUENCE_CHAR = 'a'.freeze
  FINAL_SEQUENCE_CHAR = '9'.freeze

  validates :sequence, presence: true

  class << self
    alias current first
  end

  def increment_sequence
    chars = sequence.split('')
    i = chars.length - 1

    if chars[i] == final_char
      while increment_char?(i) && chars[i] == final_char
        chars[i] = next_char(chars[i])
        i -= 1
      end
    end

    if increment_char?(i)
      chars[i] = next_char(chars[i])
    else
      chars << initial_char
    end

    update!(sequence: chars.join(''))

    self
  end

  private

  def initial_char
    INITIAL_SEQUENCE_CHAR
  end

  def final_char
    FINAL_SEQUENCE_CHAR
  end

  def next_char(char)
    char.tr('a-zA-Z0-9', 'b-zA-Z0-9a')
  end

  def increment_char?(i)
    i >= 0
  end
end
