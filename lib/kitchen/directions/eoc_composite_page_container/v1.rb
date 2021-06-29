# frozen_string_literal: true

module Kitchen::Directions::EocCompositePageContainer
  class V1
    renderable

    def bake(metadata_source:, klass:, content:, append_to:, uuid_prefix: '.')
      @klass = klass
      @metadata = metadata_source.children_to_keep.copy
      @title = I18n.t(:"eoc.#{klass}")
      @uuid_prefix = uuid_prefix
      @content = content
      @in_composite_chapter = append_to.is?(:composite_chapter)

      append_to.append(child: render(file:
        '../../templates/eoc_section_title_template.xhtml.erb'))
    end
  end
end
