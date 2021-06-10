# frozen_string_literal: true

# Monkey patches for +Integer+
#
class Integer
  ROMAN_NUMERALS = %w[0 i ii iii iv v vi vii viii ix x].freeze

  # Formats as different types of integers, including roman numerals.
  #
  # @return [Integer]
  #
  def to_format(format)
    case format
    when :arabic
      self
    when :roman
      raise 'Unknown conversion to Roman numerals' if self >= ROMAN_NUMERALS.size

      ROMAN_NUMERALS[self]
    end
  end
end
