module Kitchen
  class PageElement < Element

    attr_accessor :chapter, :unit, :book

    COUNTER_NAME = :page

    # TODO maybe can just be "type" instead of "short_type"

    def initialize(element:)
      # @chapter = chapter
      super(node: element.raw, document: element.document, short_type: :page)
    end

    def title
      # first!("h#{chapter.title_header_number + 1}[data-type='document-title']")
      first!(document.page_title_selector)
    end

    def number_it
      title.prepend child: document.number_html(counter_names)
    end

    def counter_names
      [chapter&.counter_names, COUNTER_NAME].flatten.compact
    end

    def each_term
      each("span[data-type='term']") do |element|
        term = TermElement.new(element: element, page: self)
        yield term
      end
    end

    def terms
      PageElementEnumerator.new([self], :each).terms
    end

    def is_introduction?
      has_class?("introduction")
    end

  end
end
