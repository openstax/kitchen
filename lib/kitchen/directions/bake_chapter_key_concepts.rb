# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for eoc key concepts
    #
    module BakeChapterKeyConcepts
      def self.v1(chapter:, metadata_source:)
        metadata_elements = metadata_source.children_to_keep.copy

        fix_titles = chapter.pages.map do |page|
          key_concepts = page.search('section.key-concepts')
          next if key_concepts.none?

          key_concepts.search('h3').trash
          key_concepts.map do |key_concept|
            id = key_concept.id.split('fs-id')
            key_concept.prepend(child:
              <<~HTML
                <a href="##{id[0]}0">
                  <h3 data-type="document-title" id="#{id[0]}0_copy_XXX">
                    <span class="os-number">#{chapter.count_in(:book)}.#{key_concept.count_in(:chapter)}</span>
                    <span class="os-divider"> </span>
                    <span class="os-text" data-type="" itemprop="">#{page.title.text}</span>
                  </h3>
                </a>
              HTML
            )

            <<~HTML
              <div class="os-section-area">
                #{key_concept}
              </div>
            HTML
          end.compact.join("\n")
        end.compact.join("\n")

        chapter.append(child:
          <<~HTML
            <div class="os-eoc os-key-concepts-container" data-type="composite-page" data-uuid-key=".key-concepts">
              <h2 data-type="document-title">
                <span class="os-text">#{I18n.t(:eoc_key_concepts)}</span>
              </h2>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">#{I18n.t(:eoc_key_concepts)}</h1>
                #{metadata_elements.paste}
              </div>
              <div class="os-key-concepts">
                #{fix_titles}
              </div>
            </div>
          HTML
        )
      end
    end
  end
end
