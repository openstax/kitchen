# frozen_string_literal: true

module Kitchen::Directions::BakeChapterReferences
  class V1
    def bake(chapter:, metadata_source:, uuid_prefix: '.', klass: 'references')
      bake_page_references(page: chapter.introduction_page)

      chapter.non_introduction_pages.each do |page|
        bake_page_references(page: page)
      end

      content = chapter.pages.references.cut.paste

      if content.empty?
        content = Kitchen::Clipboard.new
        chapter.search('section.references').each do |section|
          section.search('h3').cut
          section.cut(to: content)
        end
        content = content.paste
      end

      Kitchen::Directions::EocCompositePageContainer.v1(
        container_key: klass,
        uuid_key: "#{uuid_prefix}#{klass}",
        metadata_source: metadata_source,
        content: content,
        append_to: chapter
      )
    end

    def bake_page_references(page:)
      return if page.nil?

      references = page.references
      return if references.none?

      title = if page.is_introduction?
                <<~HTML
                  <a href="##{page.title.id}">
                    <h3 data-type="document-title" id="#{page.title.copied_id}">
                      <span class="os-text" data-type="" itemprop="">#{page.title_text}</span>
                    </h3>
                  </a>
                HTML
              else
                Kitchen::Directions::EocSectionTitleLinkSnippet.v1(page: page)
              end

      references.each do |reference|
        Kitchen::Directions::RemoveSectionTitle.v1(section: reference)
        reference.prepend(child: title)
      end
    end
  end
end
