class ShortenedUrl < ApplicationRecord
  validates :sequence, presence: true

  class << self
    alias current first
  end

  def increment_sequence
    chars = sequence.split('')
    i = chars.length - 1

    if chars[i] == final_char
      while i >= 0 && chars[i] == final_char
        chars[i] = next_char(chars[i])
        i -= 1
      end

      chars << initial_char if i == - 1
    end

    chars[i] = next_char(chars[i]) if i > -1

    update!(sequence: chars.join(''))

    self
  end

  private

  def initial_char
    'a'
  end

  def final_char
    '9'
  end

  def next_char(char)
    char.tr('a-zA-Z0-9', 'b-zA-Z0-9a')
  end
end
