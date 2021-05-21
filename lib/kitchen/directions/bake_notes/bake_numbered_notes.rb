# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNumberedNotes
      def self.v1(book:, classes:)
        classes.each do |klass|
          book.chapters.notes("$.#{klass}").each do |note|
            bake_note(note: note)
            note.exercises.each do |exercise|
              bake_note_exercise(note: note, exercise: exercise)
            end
          end
        end
      end

      def self.bake_note(note:)
        note.wrap_children(class: 'os-note-body')

        chapter_count = note.ancestor(:chapter).count_in(:book)
        note_count = note.count_in(:chapter)
        note.prepend(child:
          <<~HTML
            <h3 class="os-title">
              <span class="os-title-label">#{note.autogenerated_title}</span>
              <span class="os-number">#{chapter_count}.#{note_count}</span>
              <span class="os-divider"> </span>
            </h3>
          HTML
        )

        return unless note['use-subtitle']

        BakeNoteSubtitle.v1(note: note)
      end

      def self.bake_note_exercise(note:, exercise:)
        exercise.add_class('unnumbered')
        # bake problem
        exercise.problem.wrap_children('div', class: 'os-problem-container')
        exercise.problem.first('strong')&.trash
        exercise.search('[data-type="commentary"]').each(&:trash)
        return unless exercise.solution

        # bake solution in place
        BakeNumberedExercise.bake_solution_v1(
          exercise: exercise, number: note.first('.os-number').text, divider: ' ')
      end
    end
  end
end
