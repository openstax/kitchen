# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeAutotitledNotes
      def self.v1(book:, classes:, bake_subtitle: true, cases: false)
        book.notes.each do |note|
          next unless (note.classes & classes).any?

          bake_note(note: note, bake_subtitle: bake_subtitle, cases: cases)
        end
      end

      def self.bake_note(note:, bake_subtitle:, cases:)
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
      end
    end
  end
end
