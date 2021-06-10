# frozen_string_literal: true

module Kitchen::Directions::BakeFootnotes
  # Difference from v1:
  # 1. top-level pages are numbered with roman numerals
  # 2. footnote counts don't reset with each new chapter
  class V2
    def bake(book:)
      book.body.element_children.only(Kitchen::PageElement,
                                      Kitchen::CompositePageElement,
                                      Kitchen::CompositeChapterElement).each do |page|
        Kitchen::Directions::BakeFootnotes.bake_footnotes_within(page, number_format: :roman)
      end

      Kitchen::Directions::BakeFootnotes.bake_footnotes_within(book.chapters)
    end
  end
end
