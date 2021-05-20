# frozen_string_literal: true

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

      def quick_matches?(selector_str)
        # selector is a string literal
        selectors = selector_str.split(', ')
        val = nil
        selectors.each do |selector|
          val = matcher_helper(selector)
          return true if val
        end
        raise "Unrecognized selector #{selector_str}" if val.nil?

        val
      end

      def matcher_helper(selector)
        case selector
        when /\A\.([\w-]+)\z/ # classes
          classes.include?(selector[1..-1])
        when /\A(\w+)\z/ # just a name
          name == selector
        when /\A([\w.]+)\z/ # name and one class
          el_name, el_class = selector.split('.')
          name == el_name && classes.include?(el_class)
        when /(\w*)\[([\w-]+)=["|']([\w-]+)["|']\]/ # name[attribute="value"] or [attribute="value"]
          _, el_name, attribute, value = selector.match(/(\w*)\[([\w-]+)=["|']([\w-]+)["|']\]/).to_a
          self[:"#{attribute}"] == value && (el_name.empty? ? true : name == el_name)
        end
      end

      def classes
        self[:class]&.split || []
      end
    end
  end
end
