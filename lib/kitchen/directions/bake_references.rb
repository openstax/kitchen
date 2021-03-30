# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for EOB references
    #
    module BakeReferences
      def self.v1(book:)
        book.chapters.pages.references.each do |reference|
          reference.prepend(child:
            <<~HTML
              <span class="os-reference-number">#{reference.count_in(:chapter)}</span>
            HTML
          )
        end

        chapter_references = book.chapters.pages.references.cut

        book.chapters.each do |chapter|
          chapter.append(child:
            <<~HTML
              <div class="os-chapter-area">
                #{chapter.title.text}
                #{chapter_references.paste}
              </div>
            HTML
          )
        end

        chapter_area_references = book.chapters.search('.os-chapter-area').cut

        book.body.append(child:
          <<~HTML
            <div class="os-eob os-reference-container" data-type="composite-page" data-uuid-key=".reference">
              <h1 data-type="document-title">
                <span class="os-text">#{I18n.t(:references)}</span>
              </h1>
              #{chapter_area_references.paste}
            </div>
          HTML
        )
      end
    end
  end
end
