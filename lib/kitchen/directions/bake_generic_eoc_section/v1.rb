# frozen_string_literal: true

module Kitchen::Directions::BakeGenericEocSection
  class V1
    renderable

    def bake(chapter:, metadata_source:, klass:, append_to: nil, uuid_prefix: '.',
             include_intro: true)
      # Transforms the content of the section according to the given strategies, if given
      section_clipboard = Kitchen::Clipboard.new
      sections = if include_intro
                   chapter.pages.search("$.#{klass}")
                 else
                   chapter.non_introduction_pages.search("$.#{klass}")
                 end
      sections.each { |section| yield section } if block_given?
      sections.cut(to: section_clipboard)

      return if section_clipboard.none?

      Kitchen::Directions::EocCompositePageContainer.v1(
        metadata_source: metadata_source,
        content: section_clipboard.paste,
        klass: klass,
        append_to: append_to || chapter,
        uuid_prefix: uuid_prefix
      )
    end
  end
end
