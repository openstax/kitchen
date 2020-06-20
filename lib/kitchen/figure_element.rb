module Kitchen
  class FigureElement < Element

    attr_reader :chapter

    def initialize(element:, chapter:)
      @chapter = chapter
      super(node: element.raw, number: element.number, document: element.document)
    end

    def caption
      first("figcaption")
    end

  end
end
