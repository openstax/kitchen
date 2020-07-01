module Kitchen
  class NoteElement < ElementBase

    TITLE_TRANSLATION_KEYS = %w(
      link-to-learning
      everyday-life
      sciences-interconnect
      chemist-portrait
    )

    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: NoteElementEnumerator,
            short_type: :note)
    end

    def title
      block_error_if(block_given?)
      first("[data-type='title']")
    end

    def indicates_autogenerated_title?
      translation_key_in(TITLE_TRANSLATION_KEYS).present?
    end

    def autogenerated_title
      translation_key = translation_key_in(TITLE_TRANSLATION_KEYS)
      I18n.t(:"notes.#{document.short_name}.#{translation_key}", default: :"notes.#{translation_key}")
    end

    def translation_key_in(possible_translation_keys)
      keys = possible_translation_keys & classes
      raise("too many translation keys: #{keys.join(', ')}") if keys.many?
      keys.first
    end

  end
end
