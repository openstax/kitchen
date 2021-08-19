# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeChapterIntroductions
      def self.v1(book:)
        V1.new.bake(
          book: book
        )
      end

      def self.v2(book:, chapter_objectives_strategy:)
        V2.new.bake(
          book: book,
          chapter_objectives_strategy: chapter_objectives_strategy
        )
      end

      def self.bake_chapter_objectives(chapter:, chapter_objectives_strategy: :default)
        BakeChapterObjectives.new.bake(
          chapter: chapter,
          chapter_objectives_strategy: chapter_objectives_strategy
        )
      end

      def self.bake_chapter_outline(chapter_objectives_html:)
        BakeChapterOutline.new.bake(
          chapter_objectives_html: chapter_objectives_html
        )
      end

      def self.v1_update_selectors(something_with_selectors)
        something_with_selectors.selectors.title_in_introduction_page =
          ".intro-text > [data-type='document-title']"
      end
    end
  end
end
