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
          BakeGenericEocSection.v1(
            chapter: chapter,
            metadata_source: metadata_source,
            klass: 'further-research',
            append_to: nil,
            uuid_prefix: uuid_prefix,
            include_intro: false
          ) do |further_research|
            further_research.first("[data-type='title']")&.trash # get rid of old title if exists
            title = EocSectionTitleLinkSnippet.v1(page: further_research.ancestor(:page))
            further_research.prepend(child: title)
            further_research.first('h3')[:itemprop] = 'name'
          end
        end
      end
    end
  end
end
