# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for further research
    #
    module BakeFurtherResearch
      def self.v1(chapter:, metadata_source:, uuid_prefix: '.')
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          uuid_prefix: uuid_prefix)
      end

      class V1
        renderable
        def bake(chapter:, metadata_source:, uuid_prefix: '.')
          further_researches = Clipboard.new

          chapter.non_introduction_pages.each do |page|
            further_research = page.first('.further-research')
            next unless further_research.present?

            further_research.first("[data-type='title']")&.trash # get rid of old title if exists
            title = EocSectionTitleLinkSnippet.v1(page: page)
            further_research.prepend(child: title)
            further_research.first('h3')[:itemprop] = 'name'
            further_research.cut(to: further_researches)
          end

          return if further_researches.none?

          MoveEocContentToCompositePage.v1(
            metadata_source: metadata_source,
            content: further_researches.paste,
            klass: 'further-research',
            append_to: chapter,
            uuid_prefix: uuid_prefix
          )
        end
      end
    end
  end
end
