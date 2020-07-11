module Kitchen::Directions::BakeFootnotes
  class V1

    def bake(book:)
      # Footnotes are numbered either within their top-level pages (preface,
      # appendices, etc) or within chapters. Tackle each case separately

      book.body.element_children.only(Kitchen::PageElement,
                                      Kitchen::CompositePageElement).each do |page|
        bake_footnotes_within(page)
      end

      book.chapters.each do |chapter|
        bake_footnotes_within(chapter)
      end
    end

    def bake_footnotes_within(container)
      footnote_number = 0
      aside_id_to_footnote_number = {}

      container.search("aside").each do |aside|
        footnote_number += 1
        aside_id_to_footnote_number[aside.id] = footnote_number
        aside.prepend(child: "<div class='footnote-number'>#{footnote_number}</div>")
      end

      container.search("a[role='doc-noteref']").each do |anchor|
        anchor.replace_children(with:
          aside_id_to_footnote_number[anchor[:href][1..-1]].to_s
        )
      end
    end

  end
end
