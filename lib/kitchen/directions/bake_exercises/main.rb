# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeExercises
      def self.v1(book:, classname:)
        V1.new.bake(book: book, classname: classname)
      end
    end
  end
end
