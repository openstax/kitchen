# frozen_string_literal: true

module Kitchen::Directions::BakeReferences
  class V3
    renderable

    def bake(book:, metadata_source:)
      @metadata = metadata_source.children_to_keep.copy
      @klass = 'references'
      @uuid_prefix = '.'
      @title = I18n.t(:references)

      book.chapters.each do |chapter|
        chapter.pages.each do |page|
          page.references.each do |reference|
            reference.titles.trash
            reference.prepend(child:
              Kitchen::Directions::EocSectionTitleLinkSnippet.title_snipet(
                page: page,
                title_tag: 'h2'
              )
            )

            # title.name = 'h2'
            # title['data-type'] = 'document-title'
            # title['id'] = page.title.copied_id
            # title.inner_html = Kitchen::Directions::EocSectionTitleLinkSnippet.title_snipet(
            #   page: page,
            #   title_tag: 'h2'
            # )
          end
        end
      end

      chapter_area_references = book.chapters.search('section.references').cut
      @content = chapter_area_references.paste
      book.body.append(child: render(file:
        '../../templates/eob_section_title_template.xhtml.erb'))
    end
  end
end
