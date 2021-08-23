# frozen_string_literal: true

module Kitchen
  # An element for an example
  #
  class InjectedQuestionElement < ElementBase

    # Creates a new +InjectedQuestionElement+
    #
    # @param node [Nokogiri::XML::Node] the node this element wraps
    # @param document [Document] this element's document
    #
    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: InjectedQuestionElementEnumerator)
    end

    # Returns the short type
    # @return [Symbol]
    #
    def self.short_type
      :injected_question
    end

    # Returns the question stimulus as an element.
    #
    # @return [Element]
    #
    def stimulus
      first('div[data-type="question-stimulus"]')
    end

    # Returns the question stem as an element.
    #
    # @return [Element]
    #
    def stem
      first('div[data-type="question-stem"]')
    end

    # Returns the list of answers as an element.
    #
    # @return [Element]
    #
    def answers
      first("ol[data-type='question-answers']")
    end

    # Returns the solution element.
    #
    # @return [Element]
    #
    def solution
      first("div[data-type='question-solution']")
    end
  end
end
