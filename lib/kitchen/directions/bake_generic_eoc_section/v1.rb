# frozen_string_literal: true

module Kitchen::Directions::BakeGenericEocSection
  class V1
    renderable

    def bake(chapter:, metadata_source:, klass:, append_to: nil, uuid_prefix: '.',
             content_transform: [])
      @klass = klass
      @metadata = metadata_source.children_to_keep.copy
      @title = I18n.t(:"eoc.#{klass}")
      @uuid_prefix = uuid_prefix

      # Transforms the content of the section according to the given strategies, if given
      section_clipboard = Kitchen::Clipboard.new
      sections = chapter.search("$.#{klass}")
      content_transform.each do |strat|
        sections.each do |section|
          Kitchen::Directions::EocContentTransform.v1(section: section, strategy: strat)
        end
      end
      sections.cut(to: section_clipboard)

      return if section_clipboard.none?

      @content = section_clipboard.paste

      append_to_element = append_to || chapter
      @in_composite_chapter = append_to_element.is?(:composite_chapter)

      append_to_element.append(child: render(file:
        '../../templates/eoc_section_title_template.xhtml.erb'))
    end
  end
end
