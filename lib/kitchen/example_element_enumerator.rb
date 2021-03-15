# frozen_string_literal: true

module Kitchen
  # An enumerator for example elements
  #
  class ExampleElementEnumerator < ElementEnumeratorBase

    # Returns a factory for this enumerator
    #
    # @return [ElementEnumeratorFactory]
    #
    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: "div[data-type='example']", # TODO: element.document.selectors.example
        sub_element_class: ExampleElement,
        enumerator_class: self
      )
    end

  end
end
