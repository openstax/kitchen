# frozen_string_literal: true

module Kitchen::Directions::BakeChapterKeyEquations
  class V1
    renderable
    def bake(chapter:, metadata_source:, append_to:, uuid_prefix:)
      @metadata = metadata_source.children_to_keep.copy
      @klass = 'key-equations'
      @title = I18n.t(:eoc_key_equations)
      @uuid_prefix = uuid_prefix

      chapter.key_equations.search('h3').trash

      return if chapter.key_equations.none?

      @content = chapter.key_equations.cut.paste

      append_to_element = append_to || chapter
      @in_composite_chapter = append_to.present?

      append_to_element.append(child: render(file:
        '../../templates/eoc_section_title_template.xhtml.erb'))
    end
  end
end