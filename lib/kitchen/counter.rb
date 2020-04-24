module Kitchen
  class Counter # hehe

    def initialize
      reset
    end

    # Increase the value of the counter
    #
    # @param by [Integer] the amount to increase by
    #
    def increment(by: 1)
      @value += by
    end

    # (see #increment)
    alias_method :inc, :increment

    # Returns the value of the counter
    #
    # @return [Integer]
    def get
      @value
    end

    # Reset the value of the counter
    #
    # @param to [Integer] the value to reset to
    def reset(to: 0)
      @value = to
    end

  end
end
