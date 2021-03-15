# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeExercises
      def self.v1(book:)
        V1.new.bake(book: book)
      end

      def self.v3(book:, class_names:)
        V3.new.bake(book: book, class_names: class_names)
      end

      def self.example_exercises(exercise:)
        InPlace.new.example_exercises(exercise: exercise)
      end

      def self.note_exercises(exercise:)
        InPlace.new.note_exercises(exercise: exercise)
      end

      def self.section_exercises(exercise:, number:)
        InPlace.new.section_exercises(exercise: exercise, number: number)
      end
    end
  end
end
