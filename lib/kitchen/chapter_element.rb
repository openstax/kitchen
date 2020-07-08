module Kitchen
  class ChapterElement < ElementBase

    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: ChapterElementEnumerator,
            short_type: :chapter)
    end

    def title
      # Get the title in the immediate children, not the one in the metadata.  Could use
      # CSS of ":not([data-type='metadata']) > [data-type='document-title'], [data-type='document-title']"
      # but xpath is shorter
      first!("./*[@data-type = 'document-title']")
    end

    def introduction_page
      pages('.introduction').first
    end

    def glossaries
      search("div[data-type='glossary']")
    end

    def key_equations
      search("section.key-equations")
    end

    def self.is_the_element_class_for?(node)
      node['data-type'] == "chapter"
    end

  end
end
