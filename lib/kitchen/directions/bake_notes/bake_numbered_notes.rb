# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNumberedNotes
      def self.v1(book:, classes:)
        classes.each do |klass|
          book.chapters.notes("$.#{klass}").each do |note|
            bake_note(note: note)
            bake_note_exercise(note: note)
          end
        end
      end

      def self.bake_note(note:)
        note.wrap_children(class: 'os-note-body')

        chapter_count = note.ancestor(:chapter).count_in(:book)
        note_count = note.count_in(:chapter)
        note.prepend(child:
          <<~HTML
            <div class="os-title">
              <span class="os-title-label">#{note.autogenerated_title}</span>
              <span class="os-number">#{chapter_count}.#{note_count}</span>
              <span class="os-divider"> </span>
            </div>
          HTML
        )
      end

      def self.bake_note_exercise(note:)
        exercise = note.exercises.first
        return unless exercise

        exercise.solution ? exercise.add_class('os-hasSolution unnumbered') : exercise.add_class('unnumbered')
        # bake problem
        exercise.problem.wrap_children('div', class: 'os-problem-container')
        exercise.problem.first('strong')&.trash
        solution = exercise.solution
        return unless solution

        # bake solution in place
        solution[:id] = "#{exercise[:id]}-solution"
        solution_number = note.first('.os-number').text
        solution.replace_children(with:
          <<~HTML
            <a class="os-number" href="##{exercise[:id]}">#{solution_number}</a>
            <span class="os-divider"> </span>
            <div class="os-solution-container">
              #{solution.children}
            </div>
          HTML
        )
      end
    end
  end
end
