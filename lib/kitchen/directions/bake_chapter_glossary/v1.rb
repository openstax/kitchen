# frozen_string_literal: true

module Kitchen::Directions::BakeChapterGlossary
  class V1
    renderable

    class SortableDefinition
      attr_reader :definition_text

      def initialize(definition_text:)
        @definition_text = definition_text
      end

      def <=>(other)
        I18n.sort_strings(definition_text, other.definition_text)
      end
    end

    class Definition

      # Text from tag dt
      attr_reader :term_text

      # Text from tag dd
      attr_reader :description_text

      # Clipboard with content of dl tag
      attr_reader :def_content

      def initialize(term_text:, description_text:, def_content:)
        @term_text = term_text.strip
        @description_text = description_text.strip
        @def_content = def_content
      end

      def sort_by_term!
        SortableDefinition.new(definition_text: term_text)
      end

      def sort_by_description!
        SortableDefinition.new(definition_text: description_text)
      end
    end

    class Glossary
      attr_reader :definitions

      def initialize
        @definitions = []
      end

      def add_definition(definition)
        @definitions.push(definition)
      end

      def sorted
        @definitions.sort_by! do |definition|
          [definition.sort_by_term!, definition.sort_by_description!]
        end

        self
      end
    end

    def bake(chapter:, metadata_source:, append_to: nil, uuid_prefix: '')
      @metadata = metadata_source.children_to_keep.copy
      @klass = 'glossary'
      @title = I18n.t(:eoc_key_terms_title)
      @uuid_prefix = uuid_prefix
      @glossary = Glossary.new

      chapter.glossaries.search('dl').each do |definition_element|

        @glossary.add_definition(
          Definition.new(
            term_text: definition_element.first('dt').text.downcase,
            description_text: definition_element.first('dd').text.downcase,
            def_content: definition_element.cut
          )
        )
      end

      chapter.glossaries.trash

      @content = render(file: 'v1.xhtml.erb')

      append_to_element = append_to || chapter
      @in_composite_chapter = append_to_element.is?(:composite_chapter)

      append_to_element.append(child: render(file:
        '../../templates/eoc_section_title_template.xhtml.erb'))
    end
  end
end
