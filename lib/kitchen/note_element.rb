# frozen_string_literal: true

module Kitchen
  # An element for a note
  #
  class NoteElement < ElementBase

    # Creates a new +NoteElement+
    #
    # @param node [Nokogiri::XML::Node] the node this element wraps
    # @param document [Document] this element's document
    #
    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: NoteElementEnumerator,
            short_type: :note)
    end

    # Returns the note's title element
    #
    # @return [Element, nil]
    #
    def title
      block_error_if(block_given?)
      first("[data-type='title']")
    end

    # Returns true if the note's title is autogenerated
    #
    # @return [Boolean]
    #
    def indicates_autogenerated_title?
      detected_note_title_key != 0 && detected_note_title_key.present?
    end

    # Get the autogenerated title for this note
    #
    # @return [String]
    #
    def autogenerated_title
      if indicates_autogenerated_title?
        I18n.t(:"notes.#{detected_note_title_key}")
      else
        "unknown title for note with classes #{classes}"
      end
    end

    # Returns true if this class represents the element for the given node
    #
    # @param node [Nokogiri::XML::Node] the underlying node
    # @return [Boolean]
    #
    def self.is_the_element_class_for?(node)
      node['data-type'] == 'note'
    end

    protected

    def detected_note_title_key
      @detected_note_title_key ||= begin
        return 0 if classes.empty? || !I18n.t('.').key?(:notes)

        possible_keys = I18n.t(:notes).keys.map(&:to_s)
        keys = possible_keys & classes

        raise("too many translation keys: #{keys.join(', ')}") if keys.many?
        return 0 if keys.empty?

        keys.first
      end
    end
  end
end
