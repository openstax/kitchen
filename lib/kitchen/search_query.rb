# frozen_string_literal: true

module Kitchen
  # Records the search history that was used to find a certain element
  #
  class SearchQuery
    attr_accessor :css_or_xpath, :only, :except

    def initialize(css_or_xpath: nil, only: nil, except: nil)
      @css_or_xpath = css_or_xpath
      @only = only
      @except = except
    end

    def conditions_match?(element)
      return true if !only && !except
      return false if except&.call(element)
      return true if only&.call(element)
    end

    def apply_default_css_or_xpath_and_normalize(default_css_or_xpath)
      [css_or_xpath || '$'].flatten.map do |item|
        item.gsub(/\$/, [default_css_or_xpath].flatten.join(', '))
      end
    end

    def to_s
      raise "NYI"
    end

  end
end
