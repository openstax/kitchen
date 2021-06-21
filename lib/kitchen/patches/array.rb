# frozen_string_literal: true

# Monkey patches for +Integer+
#
class Array

  # Receives a string to add as prefix in each item of the array
  #
  # @return [String]
  #
  def prefix(string:)
    result = []

    each do |item|
      result << "#{string}#{item}"
    end

    result
  end
end
