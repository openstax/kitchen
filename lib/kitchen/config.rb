# frozen_string_literal: true

module Kitchen
  # Kitchen configuration
  #
  class Config

    # Named CSS or XPath selectors
    #
    # @return [Selectors::Base]
    #
    attr_reader :selectors

    # @!attribute [rw] enable_all_namespaces
    #
    # @return [Boolean]
    #
    attr_accessor :enable_all_namespaces

    # Creates a new config from a file (not implemented)
    #
    def self.new_from_file(_file)
      raise 'NYI'
    end

    # Creates a new Config instance
    #
    def initialize(hash: {}, selectors: nil)
      @selectors = selectors || Kitchen::Selectors::Standard1.new
      @enable_all_namespaces = hash[:enable_all_namespaces] || true
      @hash = hash
    end
  end
end
