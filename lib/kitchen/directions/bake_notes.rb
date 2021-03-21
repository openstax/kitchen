# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNotes
      def self.v1(book:)
        book.notes('$:not(.checkpoint):not(.theorem)').each do |note|
          title = note.title&.cut

          note.replace_children(with:
            <<~HTML
              <div class="os-note-body">#{note.children}</div>
            HTML
          )

          if title
            if note.indicates_autogenerated_title?
              note.prepend(child:
                <<~HTML
                  <h3 class="os-title" data-type="title">
                    <span class="os-title-label">#{note.autogenerated_title}</span>
                  </h3>
                HTML
              )

              title.name = 'h4'
              title.add_class('os-subtitle')
              title.replace_children(with:
                <<~HTML
                  <span class="os-subtitle-label">#{title.children}</span>
                HTML
              )
              note.first!('.os-note-body').prepend(child: title.raw)
            else
              title.name = 'h3'
              title.add_class('os-title')
              title.replace_children(with:
                <<~HTML
                  <span data-type="" id="#{title.id}" class="os-title-label">#{title.children}</span>
                HTML
              )
              title.remove_attribute('id')
              note.prepend(child: title.raw)
            end
          else
            note.prepend(child:
              <<~HTML
                <h3 class="os-title" data-type="title">
                  <span class="os-title-label">#{note.has_class?('media-2') ? 'Media' : note.autogenerated_title}</span>
                </h3>
              HTML
            )
          end
        end
      end

      def self.bake_checkpoint_note(note:, number:)
        note.replace_children(with:
          <<~HTML
            <div class="os-note-body">#{note.children}</div>
          HTML
        )
        note.prepend(child:
          <<~HTML
            <h3 class="os-title">
              <span class="os-title-label">Checkpoint </span>
              <span class="os-number">#{number}</span>
              <span class="os-divider"> </span>
            </h3>
          HTML
        )

        exercise = note.exercises.first
        solution = exercise.solution

        return unless solution.present?

        exercise.add_class('os-hasSolution unnumbered')
        solution.replace_children(with:
          <<~HTML
            <span class="os-divider"> </span>
            <a class="os-number" href="##{exercise.id}">#{number}</a>
            <div class="os-solution-container ">#{solution.children}</div>
          HTML
        )
      end
    end
  end
end
