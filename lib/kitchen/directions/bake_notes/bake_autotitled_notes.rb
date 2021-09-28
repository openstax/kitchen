# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeAutotitledNotes
      def self.v1(book:, classes:, bake_subtitle: true, cases: false, bake_exercises: false)
        book.notes.each do |note|
          next unless (note.classes & classes).any?

          bake_note(
            note: note, bake_subtitle: bake_subtitle, cases: cases, bake_exercises: bake_exercises)
        end
      end

      def self.bake_note(note:, bake_subtitle:, cases:, bake_exercises:)
        Kitchen::Directions::BakeIframes.v1(outer_element: note)
        note.wrap_children(class: 'os-note-body')

        if bake_subtitle
          BakeNoteSubtitle.v1(note: note, cases: cases)
        else
          note.title&.trash
        end

        note.prepend(child:
          <<~HTML
            <h3 class="os-title" data-type="title">
              <span class="os-title-label">#{note.autogenerated_title}</span>
            </h3>
          HTML
        )

        bake_unclassified_exercises(note: note) if bake_exercises
      end

      def self.bake_unclassified_exercises(note:)
        note.exercises.each do |exercise|
          exercise.problem.wrap_children('div', class: 'os-problem-container')

          unless exercise.has_class?('unnumbered')
            exercise.problem.prepend(child:
              <<~HTML
                <span class="os-title-label">#{I18n.t(:"exercises.exercise")} </span>
                <span class="os-number">#{exercise.count_in(:note)}</span>
              HTML
            )
          end

          next unless exercise.solution

          exercise.solution.wrap_children('div', class: 'os-solution-container')

          exercise.solution.prepend(child:
            <<~HTML
              <span class="os-title-label">#{I18n.t(:"exercises.solution")}</span>
            HTML
          )
        end
      end
    end
  end
end
