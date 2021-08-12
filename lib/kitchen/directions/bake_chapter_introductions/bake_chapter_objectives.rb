# frozen_string_literal: true

module Kitchen::Directions::BakeChapterIntroductions
  class BakeChapterObjectives
    def bake(chapter:, chapter_objectives_strategy: :default)
      chapter_outline_html = ''

      case chapter_objectives_strategy
      when :default
        chapter_outline_html = chapter.non_introduction_pages.map do |page|
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
      when :preexisting_title
        chapter_objectives = chapter.first('[data-type="note"].chapter-objectives')&.cut
        if chapter_objectives
          chapter_objectives.search('div[data-type="title"]')&.trash
          chapter_objectives.wrap_children('div', class: 'os-note-body')
          chapter_objectives.prepend(child:
            <<~HTML
              <h3 class="os-title" data-type="title">
                <span class="os-title-label">#{I18n.t(:chapter_objectives)}</span>
              </h3>
            HTML
          )
          chapter_outline_html = chapter_objectives.cut
        end
      when :none
        return
      else
        raise 'No such strategy'
      end

      chapter_outline_html
    end
  end
end
