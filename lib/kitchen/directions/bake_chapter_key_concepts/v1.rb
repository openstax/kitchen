# frozen_string_literal: true

module Kitchen::Directions::BakeChapterKeyConcepts
  class V1
    renderable
    def bake(chapter:, metadata_source:, append_to:)
      @metadata_elements = metadata_source.children_to_keep.copy

      @key_concepts = []
      key_concepts_clipboard = Kitchen::Clipboard.new
      chapter.non_introduction_pages.each do |page|
        key_concepts = page.key_concepts
        next if key_concepts.none?

        key_concepts.search('h3').trash
        title = bake_concept_title(page: page)
        key_concepts.each do |key_concept|
          key_concept.prepend(child: title)
          key_concept&.cut(to: key_concepts_clipboard)
        end
        @key_concepts.push(key_concepts_clipboard.paste)
        key_concepts_clipboard.clear
      end

      append_to_element = append_to || chapter

      append_to_element.append(child: render(file: 'key_concepts.xhtml.erb'))
    end

    protected

    def bake_concept_title(page:)
      chapter = page.ancestor(:chapter)
      original_id = page.title[:id]
      copied_id = page.document.copy_id(original_id)
      <<~HTML
        <a href="##{original_id}">
          <h3 data-type="document-title" id="#{copied_id}">
            <span class="os-number">#{chapter.count_in(:book)}.#{page.count_in(:chapter)}</span>
            <span class="os-divider"> </span>
            <span class="os-text" data-type="" itemprop="">#{page.title.text}</span>
          </h3>
        </a>
      HTML
    end
  end
end
