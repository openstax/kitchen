# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directons for eoc glossary
    #
    module BakeChapterGlossary
      def self.v1(chapter:, metadata_source:, append_to: nil, uuid_prefix: nil)
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          append_to: append_to,
          uuid_prefix: uuid_prefix
        )
      end

      class V1
        renderable
        def bake(chapter:, metadata_source:, append_to:, uuid_prefix:)
          @metadata = metadata_source.children_to_keep.copy
          @klass = 'glossary'
          @title = I18n.t(:eoc_key_terms_title)
          @uuid_prefix = uuid_prefix

          definitions = chapter.glossaries.search('dl').cut
          definitions.sort_by! do |definition|
            [definition.first('dt').text.downcase, definition.first('dd').text.downcase]
          end

          chapter.glossaries.trash

          return if definitions.none?

          @content = definitions.paste

          append_to_element = append_to || chapter
          @in_composite_chapter = append_to_element[:'data-type'] == 'composite-chapter'

          append_to_element.append(child: render(file:
            '../templates/eoc_section_title_template.xhtml.erb'))
        end
      end
    end
  end
end
