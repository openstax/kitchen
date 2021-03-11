# frozen_string_literal: true

module Kitchen
  # Records the search history that was used to find a certain element
  #
  class SearchQuery
    attr_reader :css_or_xpath
    attr_reader :only
    attr_reader :except

    #
    # @param css_or_xpath [String, Array<String>] selectors to use to limit iteration
    #   results
    # @param only [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will only be included in the
    #   search results if the method or callable returns true
    # @param except [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will not be included in the
    #   search results if the method or callable returns false
    #
    def initialize(css_or_xpath: nil, only: nil, except: nil)
      @css_or_xpath = css_or_xpath
      @only = only.is_a?(String) ? only.to_sym : only
      @except = except.is_a?(String)? except.to_sym : except
    end

    # Returns true iff the element passes the `only` and `except` conditions
    #
    # @return [Boolean]
    #
    def conditions_match?(element)
      return false if except&.call(element)
      return true if only&.call(element)

      true
    end

    def apply_default_css_or_xpath_and_normalize(default_css_or_xpath=nil)
      @as_type = nil
      @css_or_xpath = [css_or_xpath || '$'].flatten.map do |item|
        item.gsub(/\$/, [default_css_or_xpath].flatten.join(', '))
      end
    end

    def as_type
      @as_type ||= [
        [css_or_xpath].flatten.join(','),
        ("only:#{only.is_a?(Symbol) ? only : 'proc'}" if only),
        ("except:#{except.is_a?(Symbol) ? except : 'proc'}" if except),
      ].compact.join(';')
    end

    def to_s
      as_type
    end
  end
end
