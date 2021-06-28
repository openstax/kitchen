# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for eoc summary
    #
    module BakeChapterSummary
      def self.v1(chapter:, metadata_source:, klass: 'summary', uuid_prefix: '.')
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          uuid_prefix: uuid_prefix,
          klass: klass
        )
      end

      class V1
        renderable
        def bake(chapter:, metadata_source:, uuid_prefix: '.', klass: 'summary')
          summaries = Clipboard.new

          # TODO: include specific page types somehow without writing it out
          chapter.non_introduction_pages.each do |page|
            summary = page.summary

            next if summary.nil?

            summary.first("[data-type='title']")&.trash # get rid of old title if exists
            summary_title = page.title.copy
            summary_title.name = 'h3'

            unless summary_title.children.search('span.os-number').present?
              summary_title.replace_children(with:
                <<~HTML
                  <span class="os-number">#{chapter.count_in(:book)}.#{page.count_in(:chapter)}</span>
                  <span class="os-divider"> </span>
                  <span class="os-text" data-type="" itemprop="">#{summary_title.children}</span>
                HTML
              )
            end

            summary.prepend(child:
              <<~HTML
                <a href="##{page.title.id}">
                  #{summary_title.paste}
                </a>
              HTML
            )
            summary.cut(to: summaries)
          end

          return if summaries.none?

          MoveEocContentToCompositePage.v1(
            metadata_source: metadata_source,
            content: summaries.paste,
            append_to: chapter,
            klass: klass,
            uuid_prefix: uuid_prefix
          )
        end
      end
    end
  end
end
