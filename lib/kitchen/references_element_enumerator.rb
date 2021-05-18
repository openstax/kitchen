# frozen_string_literal: true

module Kitchen
  # An enumerator for table elements
  #
  class ReferenceElementEnumerator < ElementEnumeratorBase
    # Returns a factory for this enumerator
    #
    # @return [ElementEnumeratorFactory]
    #
    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: :reference,
        # default_css_or_xpath: ->(config) { config.selectors.reference },
        sub_element_class: ReferenceElement,
        enumerator_class: self
      )
    end

  end
end
