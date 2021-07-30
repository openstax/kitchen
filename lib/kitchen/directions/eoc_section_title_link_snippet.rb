# frozen_string_literal: true

module Kitchen
  module Directions
    module EocSectionTitleLinkSnippet
      def self.v1(page:)
        chapter = page.ancestor(:chapter)
        <<~HTML
          <a href="##{page.title.id}">
            <h3 data-type="document-title" id="#{page.title.copied_id}">
              <span class="os-number">#{chapter.count_in(:book)}.#{page.count_in(:chapter)}</span>
              <span class="os-divider"> </span>
              <span class="os-text" data-type="" itemprop="">#{page.title_text}</span>
            </h3>
          </a>
        HTML
      end

      def self.v2(page:)
        chapter = page.ancestor(:chapter)
        <<~HTML
          <div>
            <h3 data-type="document-title" id="#{page.title.copied_id}">
              <span class="os-number">#{chapter.count_in(:book)}.#{page.count_in(:chapter)}</span>
              <span class="os-divider"> </span>
              <span class="os-text" data-type="" itemprop="">#{page.title_text}</span>
            </h3>
          </div>
        HTML
      end

      def self.v3(page:)
        if page.is_introduction?
          os_number = ''
        else
          chapter = page.ancestor(:chapter)
          os_number =
            <<~HTML
              <span class="os-number">#{chapter.count_in(:book)}.#{page.count_in(:chapter) - 1}</span>
              <span class="os-divider"> </span>
            HTML
        end
        <<~HTML
          <a href="##{page.title.id}">
            <h3 data-type="document-title" id="#{page.title.copied_id}">
              #{os_number}
              <span class="os-text" data-type="" itemprop="">#{page.title_text}</span>
            </h3>
          </a>
        HTML
      end
    end
  end
end
