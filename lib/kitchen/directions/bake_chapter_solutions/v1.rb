# frozen_string_literal: true

module Kitchen::Directions::BakeChapterSolutions
  class V1
    renderable

    def bake(chapter:, metadata_source:, uuid_prefix: '')
      @metadata = metadata_source.children_to_keep.copy
      @klass = 'key-concepts'
      @title = I18n.t(:eoc_solutions_title)
      @uuid_prefix = uuid_prefix

      solutions_clipboard = Kitchen::Clipboard.new

      chapter.search("[data-type='solution']").each do |solution|
      end

      @content = chapter.search("[data-type='solution']").cut.paste

      @in_composite_chapter = false

      chapter.append(child: render(file:
        '../../templates/eoc_section_title_template.xhtml.erb'))
    end
  end
end
