# frozen_string_literal: true

module Kitchen::Directions::BakeChapterReferences
  class V1
    renderable

    def bake(chapter:, metadata_source:, uuid_prefix: '.', klass: 'references', from_introduction: false)
      @metadata = metadata_source.children_to_keep.copy
      @klass = klass
      @title = I18n.t(:references)
      @uuid_prefix = uuid_prefix
      @from_introduction = from_introduction

      chapter.references.search('h3').trash

      chapter.non_introduction_pages.each do |page|
        references = page.references
        next if references.none?

        references.search('h3').trash
        title = Kitchen::Directions::EocSectionTitleLinkSnippet.v1(page: page)

        references.each do |reference|
          reference.prepend(child: title)
        end
      end

      if from_introduction == true

        chapter.pages(only: :is_introduction?).each do |page|
          references = page.references
          next if references.none?

          references.search('h3').trash
          references.each do |reference|
            reference.prepend(child:
              <<~HTML
                <a href="##{page.title.id}">
                  <h3 data-type="document-title" id="#{page.title.copied_id}">
                    <span class="os-text" data-type="" itemprop="">#{page.title_text}</span>
                  </h3>
                </a>
              HTML
            )
          end
        end
      end

      @content = chapter.pages.references.cut.paste
      @in_composite_chapter = false

      chapter.append(child: render(file:
        '../../templates/eoc_section_title_template.xhtml.erb'))
    end
  end
end
