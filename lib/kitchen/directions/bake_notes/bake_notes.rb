# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNotes
      def self.v1(book:)
        warn 'WARNING! deprecated direction used: BakeNotes'

        book.notes('$:not(.checkpoint):not(.theorem)').each do |note|
          title = note.title&.cut

          note.wrap_children(class: 'os-note-body')

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
              title.wrap_children('span', class: 'os-subtitle-label')
              note.first!('.os-note-body').prepend(child: title.raw)
            else
              title.name = 'h3'
              title.add_class('os-title')
              title.wrap_children('span', data_type: '', id: title.id, class: 'os-title-label')
              title.remove_attribute('id')
              note.prepend(child: title.raw)
            end
          else
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
  end
end