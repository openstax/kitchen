# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeExercises
      def self.v1(book:)
        V1.new.bake(book: book)
      end
    end
  end
end
