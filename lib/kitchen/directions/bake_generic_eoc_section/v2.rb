# frozen_string_literal: true

module Kitchen::Directions::BakeGenericEocSection
  # Differs from V1: only iterates over sections in non introduction pages
  class V2
    renderable

    def bake(chapter:, metadata_source:, klass:, append_to: nil, uuid_prefix: '.')
      section_clipboard = Kitchen::Clipboard.new
      sections = chapter.non_introduction_pages.search("$.#{klass}")
      sections.each { |section| yield section } if block_given?
      sections.cut(to: section_clipboard)

      return if section_clipboard.none?

      Kitchen::Directions::MoveEocContentToCompositePage.v1(
        metadata_source: metadata_source,
        content: section_clipboard.paste,
        klass: klass,
        append_to: append_to || chapter,
        uuid_prefix: uuid_prefix
      )
    end
  end
end
