# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeChapterIntroductions
      def self.v1(book:, bake_chapter_objectives: true, bake_chapter_outline: true)
        V1.new.bake(
          book: book,
          bake_chapter_objectives: bake_chapter_objectives,
          bake_chapter_outline: bake_chapter_outline
        )
      end

      def self.v2(book:, bake_chapter_objectives: true, bake_chapter_outline: true)
        V2.new.bake(
          book: book,
          bake_chapter_objectives: bake_chapter_objectives,
          bake_chapter_outline: bake_chapter_outline
        )
      end

      def self.bake_chapter_objectives(chapter:, bake_chapter_objectives:, bake_chapter_outline:)
        BakeChapterObjectives.new.bake(
          chapter: chapter,
          bake_chapter_objectives: bake_chapter_objectives,
          bake_chapter_outline: bake_chapter_outline
        )
      end

      def self.v1_update_selectors(something_with_selectors)
        something_with_selectors.selectors.title_in_introduction_page =
          ".intro-text > [data-type='document-title']"
      end
    end
  end
end
