# frozen_string_literal: true

module Kitchen::Directions::BakeChapterGlossary
  class V1
    renderable

    def bake(chapter:, metadata_source:, append_to: nil, uuid_prefix: '')
      definitions = chapter.glossaries.search('dl').cut
      return if definitions.none?

      definitions.sort_by! do |definition|
        [definition.first('dt').text.downcase, definition.first('dd').text.downcase]
      end

      chapter.glossaries.trash

      Kitchen::Directions::MoveEocContentToCompositePage.v1(
        metadata_source: metadata_source,
        content: definitions.paste,
        klass: 'glossary',
        append_to: append_to || chapter,
        uuid_prefix: uuid_prefix
      )
    end
  end
end
