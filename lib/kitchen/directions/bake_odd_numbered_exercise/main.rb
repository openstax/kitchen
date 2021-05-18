# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeOddNumberedExercise
      def self.v1(composite_page:)
        V1.new.bake(composite_page: composite_page)
      end
    end
  end
end
