# frozen_string_literal: true

module Kitchen::Directions::BakeReferences
  class V2
    def bake(book:)
      book.chapters.each do |chapter|

        chapter.references.search('h3').trash

        chapter_references = chapter.pages.references.cut
        chapter_title_no_num = chapter.title.search('.os-text')

        chapter.append(child:
          <<~HTML
            <div class="os-chapter-area">
              <h2 data-type="document-title">#{chapter_title_no_num}</h2>
              #{chapter_references.paste}
            </div>
          HTML
        )
      end
    end
  end
end
