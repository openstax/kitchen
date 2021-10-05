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
            enumerator_class: FigureElementEnumerator)
    end

    # Returns the short type
    # @return [Symbol]
    #
    def self.short_type
      :figure
    end

    # Returns the caption element
    #
    # @return [Element, nil]
    #
    def caption
      first('figcaption')
    end

    # Returns the Figure Title
    #
    # @return [Element, nil]
    #
    def title
      first("div[data-type='title']")
    end

    # Returns true if the figure is a child of another figure
    #
    # @return [Boolean]
    #
    def subfigure?
      parent.name == 'figure'
    end

    # Returns true unless the figure is a subfigure or has the 'unnumbered' class,
    # unless the figure has both the 'unnumbered' and the 'splash' classes.
    #
    # @return [Boolean]
    #
    def figure_to_bake?
      return false if subfigure? || (has_class?('unnumbered') &&
                                    !has_class?('splash') && !caption &&
                                    !title)

      true
    end

    # Returns true unless the figure is a subfigure or has the 'unnumbered' class
    #
    # @return [Boolean]
    def figure_to_bake_and_count?
      return false if subfigure? || has_class?('unnumbered')

      true
    end

    # Returns true unless the figure is a not a subfigure or not has the 'unnumbered' class,
    # unless together with 'splash' classes, caption, title
    #
    # @return [Boolean]
    def figure_to_bake_without_count?
      return false if !subfigure? || (!has_class?('unnumbered') &&
                                    has_class?('splash') && caption &&
                                    title)

      true
    end
  end
end
