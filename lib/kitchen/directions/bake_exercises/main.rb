# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeExercises
      def self.v1(book:, exercise_section_classname:, exercise_section_title:)
        V1.new.bake(
          book: book,
          exercise_section_classname: exercise_section_classname,
          exercise_section_title: exercise_section_title
        )
      end
    end
  end
end
