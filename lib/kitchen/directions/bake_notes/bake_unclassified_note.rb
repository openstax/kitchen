# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeUnclassifiedNote
      def self.v1(note:)
        note.wrap_children(class: 'os-note-body')

        title = note.title&.cut
        return unless title

        note.prepend(child:
          <<~HTML
            <h3 class="os-title" data-type="title">
              <span class="os-title-label" data-type="" id="#{title[:id]}">#{title.children}</span>
            </h3>
          HTML
        )
      end
    end
  end
end
