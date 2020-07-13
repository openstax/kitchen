# Make debug output more useful (dumping entire document out is not useful)
module Nokogiri
  module XML
    # Monkey patches for Nokogiri::XML::Document
    # @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Document Nokogiri::XML::Document
    class Document
      # Hides the guts of the document when printed out so you don't get 5MB dumped into your
      # terminal
      #
      def inspect
        'Nokogiri::XML::Document <hidden for brevity>'
      end

      # Alphabetizes all attributes within the document, useful for comparing one
      # document to another (since attribute order isn't meaningful)
      #
      def alphabetize_attributes!
        traverse do |child|
          next if child.text? || child.document?

          child_attributes = child.attributes
          child_attributes.each do |key, _value|
            child.remove_attribute(key)
          end
          sorted_keys = child_attributes.keys.sort
          sorted_keys.each do |key|
            value = child_attributes[key].to_s
            child[key] = value
          end
        end
      end
    end

    # Monkey patches for Nokogiri::XML::Node
    # @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node Nokogiri::XML::Node
    class Node
      # Calls to_s on the node
      #
      # @return [String]
      #
      def inspect
        to_s
      end
    end

    SEARCH_COUNTS = Hash.new(0)

    if ENV['PROFILE']
      # Patches inside Nokogiri to count and print searches.  At end of baking
      # you can `puts Nokogiri::XML::SEARCH_COUNTS` to see the totals.  The counts
      # hash is defined outside of the if block so that code that prints it doesn't
      # explode if run without the env var.

      class XPathContext
        alias_method :original_evaluate, :evaluate
        def evaluate(search_path, handler = nil)
          SEARCH_COUNTS[search_path] += 1
          puts search_path
          original_evaluate(search_path, handler)
        end
      end
    end

  end
end
