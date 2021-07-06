# frozen_string_literal: true

# rubocop:disable Metrics/ParameterLists
# More parameters are ok here because these generic classes DRY up a lot of other code
module Kitchen::Directions::BakeGenericEocSection
  class V1
    renderable

    def bake(chapter:, metadata_source:, klass:, append_to:, uuid_prefix:,
             include_intro_page:, &block)
      section_clipboard = Kitchen::Clipboard.new
      pages = include_intro_page ? chapter.pages : chapter.non_introduction_pages
      sections = pages.search(".#{klass}")
      sections.each(&block)
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
# rubocop:enable Metrics/ParameterLists
