# frozen_string_literal: true
module Kitchen
  # An one-off element that isn't one of the main elements we have dedicated classes
  # for (like ChapterElement).  Provides a way to set an arbitrary +short_type+
  #
  class Element < ElementBase

    # Creates a new +Element+
    #
    # @param node [Nokogiri::XML::Node] the node this element wraps
    # @param document [Document] this element's document
    # @param short_type [Symbol, String] the type for this element
    #
    def initialize(node:, document:, short_type: nil)
      super(node: node,
            document: document,
            enumerator_class: ElementEnumerator,
            short_type: short_type)
    end

    # # @!method pages
    # #   Returns a pages enumerator
    # def_delegators :as_enumerator, :pages, :chapters, :terms, :figures, :notes, :tables, :examples
  end
end
