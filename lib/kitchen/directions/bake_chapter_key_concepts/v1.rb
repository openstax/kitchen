# frozen_string_literal: true

module Kitchen::Directions::BakeChapterKeyConcepts
  class V1
    renderable
    def bake(chapter:, metadata_source:, append_to:)
      @metadata = metadata_source.children_to_keep.copy
      @klass = 'key-concepts'
      @title = I18n.t(:eoc_key_concepts)

      key_concepts_clipboard = Kitchen::Clipboard.new
      chapter.non_introduction_pages.each do |page|
        key_concepts = page.key_concepts
        next if key_concepts.none?

        key_concepts.search('h3').trash
        title = Kitchen::Directions::EocSectionTitleLinkSnippet.v1(page: page)
        key_concepts.each do |key_concept|
          key_concept.prepend(child: title)
          key_concept.wrap("<div class='os-section-area'>")
          page.search('.os-section-area').first.cut(to: key_concepts_clipboard)
        end
      end

      @content = "<div class=\"os-key-concepts\"> #{key_concepts_clipboard.paste} </div>"

      append_to_element = append_to || chapter
      @in_composite_chapter = append_to.present?

      append_to_element.append(child: render(file:
        '../../templates/eoc_section_title_template.xhtml.erb'))
    end
  end
end
