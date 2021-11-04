# frozen_string_literal: true

module Kitchen::Directions
  module BakeNumberedNotes
    class V1
      def bake(book:, classes:, cases: false)
        classes.each do |klass|
          book.chapters.pages.notes("$.#{klass}").each do |note|
            bake_note(note: note, cases: cases)
            note.exercises.each do |exercise|
              BakeNoteExercise.v1(note: note, exercise: exercise)
            end
            note.injected_questions.each do |question|
              BakeNoteInjectedQuestion.v1(note: note, question: question)
            end
          end
        end
      end

      def bake_note(note:, cases: false)
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

        BakeNoteSubtitle.v1(note: note, cases: cases)
      end
    end
  end
end
