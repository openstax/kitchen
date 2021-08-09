# frozen_string_literal: true

module Kitchen::Directions::BakeReferences
  class V1
    def bake(book:)
      book.chapters.each do |chapter|
        chapter.search('[data-type="cite"]').each do |link|
          link.prepend(child:
            <<~HTML
              <sup class="os-citation-number">#{link.count_in(:chapter)}</sup>
            HTML
          )
        end

        chapter.references.each do |reference|
          reference.prepend(child:
            <<~HTML.chomp
              <span class="os-reference-number">#{reference.count_in(:chapter)}. </span>
            HTML
          )
        end

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
