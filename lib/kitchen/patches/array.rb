# frozen_string_literal: true

# Monkey patches for +Array+
#
class Array

  # Receives a string to add as prefix in each item of the array
  #
  # @return [String]
  #
  def prefix(string)
    result = []

    each { |item| result << "#{string[:string]}#{item}" }

    result
  end
end
