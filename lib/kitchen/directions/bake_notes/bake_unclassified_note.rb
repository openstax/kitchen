# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeUnclassifiedNote
      def self.v1(note:)
        note.add_class('unclassified')
        title = note.search('div[data-type="title"]').first
        title&.cut

        note.replace_children(with:
          <<~HTML
            <div class="os-note-body">#{note.children}</div>
          HTML
        )

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
