# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeExercises
      def self.v1(book:, class_name: 'section.exercises', bake_eob: true, bake_section_title: true)
        V1.new.bake(book: book, class_name: class_name, bake_eob: bake_eob, bake_section_title: bake_section_title)
      end

      def self.eob(book:, class_names:)
        EOB.new.bake(book: book, class_names: class_names)
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
