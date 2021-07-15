# frozen_string_literal: true

module Kitchen::Directions::BakeChapterReferences
  class V1
    def bake(chapter:, metadata_source:, uuid_prefix: '.', klass: 'references', module_title: true)
      bake_page_references(page: chapter.introduction_page, module_title: module_title)

      chapter.non_introduction_pages.each do |page|
        bake_page_references(page: page, module_title: module_title)
      end

      content = chapter.pages.references.cut.paste

      Kitchen::Directions::EocCompositePageContainer.v1(
        container_key: klass,
        uuid_key: "#{uuid_prefix}#{klass}",
        metadata_source: metadata_source,
        content: content,
        append_to: chapter
      )
    end

    def bake_page_references(page:, module_title:)
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
        if module_title
          reference.prepend(child: title)
        end
      end
    end
  end
end
