# frozen_string_literal: true

# rubocop:disable Metrics/ParameterLists
# More parameters are ok here because these generic classes DRY up a lot of other code
module Kitchen::Directions::EocCompositePageContainer
  class V1
    renderable

    def bake(title_key:, uuid_key:, container_class_type:, metadata_source:, content:, append_to:)
      @title = I18n.t(:"eoc.#{title_key}")
      @uuid_key = uuid_key
      @container_class_type = container_class_type
      @metadata = metadata_source.children_to_keep.copy
      @content = content
      @in_composite_chapter = append_to.is?(:composite_chapter)

      append_to.append(child: render(file:
        '../../templates/eoc_section_template.xhtml.erb'))
    end
  end
end
# rubocop:enable Metrics/ParameterLists
