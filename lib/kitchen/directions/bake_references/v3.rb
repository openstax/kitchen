# frozen_string_literal: true

module Kitchen::Directions::BakeReferences
  class V3

    def bake(book:)
      book.chapters.each do |chapter|
        chapter.pages.each do |page|
          page.references.each do |reference|
            title = reference.titles.first
            title.name = 'h2'
            title['data-type'] = 'document-title'
            title['id'] = page.title.copied_id
            title.replace_children(with:
              <<~HTML.chomp
                <span class="os-number">#{page.title.children[0].text}</span>
                <span class="os-divider"> </span>
                <span class="os-text" data-type="" itemprop="">#{page.title_text} </span>
              HTML
            )
          end
        end
      end
    end
  end
end
