# frozen_string_literal: true

module Kitchen
  # An element for a figure
  #
  class FigureElement < ElementBase

    # Creates a new +FigureElement+
    #
    # @param node [Nokogiri::XML::Node] the node this element wraps
    # @param document [Document] this element's document
    #
    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: FigureElementEnumerator,
            short_type: :figure)
    end

    # Returns the caption element
    #
    # @return [Element, nil]
    #
    def caption
      first('figcaption', "div[data-type='description']")
    end

    # Returns true if the figure is a child of another figure
    #
    # @return [Boolean]
    #

    def is_subfigure?
      parent.node.to_s.end_with?('</figure>')
    end

    # Increments the count of this element in all of this element's ancestors
    # unless it's a subfigure

    def count_as_descendant
      @ancestors.each_pair do |type, ancestor|
        @counts_in[type] = ancestor.increment_descendant_count(short_type) unless is_subfigure?
      end
    end

    # Returns true if this class represents the element for the given node
    #
    # @param node [Nokogiri::XML::Node] the underlying node
    # @return [Boolean]
    #
    def self.is_the_element_class_for?(node)
      node.name == 'figure'
    end

  end
end
