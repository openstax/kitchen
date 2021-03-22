# frozen_string_literal: true

# rubocop:disable Style/Documentation

# Make debug output more useful (dumping entire document out is not useful)
module Nokogiri
  module XML
    SEARCH_COUNTS = Hash.new(0)

    if ENV['PROFILE']
      # Patches inside Nokogiri to count and print searches.  At end of baking
      # you can `puts Nokogiri::XML::SEARCH_COUNTS` to see the totals.  The counts
      # hash is defined outside of the if block so that code that prints it doesn't
      # explode if run without the env var.

      class XPathContext
        alias_method :original_evaluate, :evaluate
        def evaluate(search_path, handler=nil)
          SEARCH_COUNTS[search_path] += 1
          puts search_path
          original_evaluate(search_path, handler)
        end
      end
    end
  end
end

# rubocop:enable Style/Documentation
