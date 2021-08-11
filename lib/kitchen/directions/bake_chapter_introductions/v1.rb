# frozen_string_literal: true

module Kitchen::Directions::BakeChapterIntroductions
  class V1
    def bake(book:, bake_chapter_objectives:, bake_chapter_outline:)
      book.chapters.each do |chapter|
        introduction_page = chapter.introduction_page

        introduction_page.search("div[data-type='description']").trash
        introduction_page.search("div[data-type='abstract']").trash

        title = introduction_page.title.cut
        title.name = 'h2'
        Kitchen::Directions::MoveTitleTextIntoSpan.v1(title: title)

        intro_content = introduction_page.search(
          "> :not([data-type='metadata']):not(.splash):not(.has-splash)"
        ).cut

        chapter_outline_html =
          Kitchen::Directions::BakeChapterIntroductions.bake_chapter_objectives(
            chapter: chapter,
            bake_chapter_objectives: bake_chapter_objectives,
            bake_chapter_outline: bake_chapter_outline
          )

        introduction_page.append(child:
          <<~HTML
            <div class="intro-body">
              #{chapter_outline_html}
              <div class="intro-text">
                #{title.paste}
                #{intro_content.paste}
              </div>
            </div>
          HTML
        )
      end

      Kitchen::Directions::BakeChapterIntroductions.v1_update_selectors(book)
    end
  end
end
