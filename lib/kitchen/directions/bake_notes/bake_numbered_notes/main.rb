# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNumberedNotes
      def self.v1(book:, classes:)
        V1.new.bake(book: book, classes: classes)
      end

      def self.v2(book:, classes:)
        V2.new.bake(book: book, classes: classes)
      end

      # V3 bakes notes tied to an example immediately previous ("Try It" notes)
      # Must be called AFTER BakeExercises
      #
      def self.v3(book:, classes:, suppress_solution: true)
        V3.new.bake(book: book, classes: classes, suppress_solution: suppress_solution)
      end

      # Used by V1, V2, V3
      def self.bake_note_exercise(note:, exercise:, divider: ' ', suppress_solution: false)
        exercise.add_class('unnumbered')
        # bake problem
        exercise.problem.wrap_children('div', class: 'os-problem-container')
        exercise.problem.first('strong')&.trash
        exercise.search('[data-type="commentary"]').each(&:trash)
        return unless exercise.solution

        # bake solution in place
        if suppress_solution
          exercise.add_class('os-hasSolution')
          exercise.solution.trash
        else
          BakeNumberedExercise.bake_solution_v1(
            exercise: exercise,
            number: note.first('.os-number').text.gsub(/#/, ''),
            divider: divider
          )
        end
      end
    end
  end
end
