# frozen_string_literal: true

module Kitchen::Directions::BakeReferences
  class V2

    def bake(book:, metadata_source:)
      @metadata = metadata_source.children_to_keep.copy
      @klass = 'references'
      @uuid_prefix = '.'
      @title = I18n.t(:references)
      chapter_references = Kitchen::Clipboard.new

      book.chapters.each do |chapter|

        chapter.search('section.references').each do |section|
          section.search('h3').cut
          section.cut(to: chapter_references)
        end

        chapter.append(child:
          <<~HTML
            <div class="os-eoc os-references-container" data-type="composite-page" data-uuid-key=".references">
              <h2 data-type="document-title">
                <span class="os-text">#{I18n.t(:references)}</span>
              </h2>
              #{chapter_references.paste}
            </div>
          HTML
        )
      end
    end
  end
end
