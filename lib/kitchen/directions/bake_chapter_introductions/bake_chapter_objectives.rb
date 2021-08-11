# frozen_string_literal: true

module Kitchen::Directions::BakeChapterIntroductions
  class BakeChapterObjectives
    def bake(chapter:, bake_chapter_objectives:, bake_chapter_outline:)
      chapter_outline_html = ''

      if bake_chapter_objectives
        outline_items_html = chapter.non_introduction_pages.map do |page|

          <<~HTML
            <div class="os-chapter-objective">
              <a class="os-chapter-objective" href="##{page.title[:id]}">
                <span class="os-number">#{chapter.count_in(:book)}.#{page.count_in(:chapter)}</span>
                <span class="os-divider"> </span>
                <span data-type="" itemprop="" class="os-text">#{page.title.children[0].text}</span>
              </a>
            </div>
          HTML
        end.join('')

        if bake_chapter_outline
          chapter_outline_html = <<~HTML
            <div class="os-chapter-outline">
              <h3 class="os-title">#{I18n.t(:chapter_outline)}</h3>
              #{outline_items_html}
            </div>
          HTML
        end
      end

      chapter_outline_html
    end
  end
end
