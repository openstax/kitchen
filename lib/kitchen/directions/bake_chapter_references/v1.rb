# frozen_string_literal: true

module Kitchen::Directions::BakeChapterReferences
  class V1
    renderable

    def bake(chapter:, metadata_source:, uuid_prefix: '.')
      @metadata = metadata_source.children_to_keep.copy
      @klass = 'references'
      @title = I18n.t(:references)
      @uuid_prefix = uuid_prefix

      chapter.search('[data-type="cite"]').each do |link|
        link.prepend(child:
          <<~HTML
            <sup class="os-citation-number">#{link.count_in(:chapter)}</sup>
          HTML
        )
        print "CITATION! "
      end

      chapter.references.each do |reference|
        reference.prepend(child:
          <<~HTML.chomp
            <span class="os-reference-number">#{reference.count_in(:chapter)}. </span>
          HTML
        )
        print "REFERENCE! "
      end

      references = chapter.pages.references.copy
      @content = references.paste

      # chapter_title_no_num = chapter.title.search('.os-text')

      @in_composite_chapter = false

      chapter.append(child: render(file:
        '../../templates/eoc_section_title_template.xhtml.erb'))
    end
  end
end
