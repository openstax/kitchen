# frozen_string_literal: true

module Kitchen
  # An enumerator for example elements
  #
  class ExerciseElementEnumerator < ElementEnumeratorBase

    # Returns a factory for this enumerator
    #
    # @return [ElementEnumeratorFactory]
    #
    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: "div[data-type='exercise']", # TODO: element.document.selectors.exercise
        sub_element_class: ExerciseElement,
        enumerator_class: self
      )
    end

  end
end
