# frozen_string_literal: true

module Kitchen::Directions::BakeReferences
  class V3
    def bake(book:)
      return unless book.references.any?

      book.chapters.pages.each do |page|
        page.references.each do |reference|
          reference.titles.trash
          reference.prepend(child:
            Kitchen::Directions::EocSectionTitleLinkSnippet.v1(
              page: page,
              title_tag: 'h2',
              wrapper: nil
            )
          )
        end
      end
    end
  end
end
