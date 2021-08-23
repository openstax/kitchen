# frozen_string_literal: true

module Kitchen::Directions::BakeNumberedNotes
  class V3
    # for the try it notes, must be called AFTER bake_exercises
    def bake(book:, classes:, suppress_solution: true)
      classes.each do |klass|
        book.chapters.notes("$.#{klass}").each do |note|
          note.wrap_children(class: 'os-note-body')
          previous_example = note.previous
          os_number = previous_example&.first('.os-number')&.children&.to_s

          note.prepend(child:
            <<~HTML
              <h3 class="os-title">
                <span class="os-title-label">#{note.autogenerated_title}</span>
                <span class="os-number">#{os_number}</span>
              </h3>
            HTML
          )

          note.title&.trash
          note.all_exercise_types.each do |exercise|
            Kitchen::Directions::BakeNumberedNotes.bake_note_exercise(
              note: note, exercise: exercise, divider: '. ', suppress_solution: suppress_solution
            )
          end
        end
      end
    end
  end
end
