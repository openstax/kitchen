# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeAutotitledNotes
      def self.v1(book:, classes:, bake_subtitle: true)
        book.notes.each do |note|
          next unless (note.classes & classes).any?

          bake_note(note: note, bake_subtitle: bake_subtitle)
        end
      end

      def self.bake_note(note:, bake_subtitle:)
        BakeNoteIFrames.v1(note: note)
        note.wrap_children(class: 'os-note-body')

        BakeNoteSubtitle.v1(note: note) if bake_subtitle

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
