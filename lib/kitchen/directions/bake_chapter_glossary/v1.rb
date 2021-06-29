# frozen_string_literal: true

module Kitchen::Directions::BakeChapterGlossary
  class V1
    renderable

    class Definition
      attr_reader :element

      def initialize(element)
        term = Kitchen::I18nString.new(element.first('dt').text.downcase)
        description = Kitchen::I18nString.new(element.first('dd').text.downcase)
        @sortable = [term, description]
        @element = element
      end

      def <=>(other)
        sortable <=> other.sortable
      end

      protected

      attr_reader :sortable
    end

    def bake(chapter:, metadata_source:, append_to: nil, uuid_prefix: '')
      @glossary = []

      chapter.glossaries.search('dl').each do |definition_element|
        @glossary.push(Definition.new(definition_element.cut))
      end

      chapter.glossaries.trash

      content = @glossary.sort.map { |definition| definition.element.paste }.join

      Kitchen::Directions::EocCompositePageContainer.v1(
        metadata_source: metadata_source,
        content: content,
        append_to: append_to || chapter,
        klass: 'glossary',
        uuid_prefix: uuid_prefix
      )
    end
  end
end
