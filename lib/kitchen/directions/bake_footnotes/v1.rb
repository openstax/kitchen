# frozen_string_literal: true

module Kitchen::Directions::BakeFootnotes
  class V1

    def bake(book:)
      # Footnotes are numbered either within their top-level pages (preface,
      # appendices, etc) or within chapters. Tackle each case separately

      book.body.element_children.only(Kitchen::PageElement,
                                      Kitchen::CompositePageElement,
                                      Kitchen::CompositeChapterElement).each do |page|
        Kitchen::Directions::BakeFootnotes.bake_footnotes_within(page)
      end

      book.chapters.each do |chapter|
        Kitchen::Directions::BakeFootnotes.bake_footnotes_within(chapter)
      end
    end
  end
end
