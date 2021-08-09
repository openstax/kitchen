# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for EOB references
    #
    module BakeReferences
      def self.v1(book:, metadata_source:)
        V1.new.bake(book: book)

        chapter_area_references = book.chapters.search('.os-chapter-area').cut

        section(
          book: book,
          metadata_source: metadata_source,
          chapter_area_references: chapter_area_references.paste,
          plural: false
        )
      end

      def self.v2(book:, metadata_source:)
        V2.new.bake(book: book)

        chapter_area_references = book.chapters.search('.os-chapter-area').cut

        section(
          book: book,
          metadata_source: metadata_source,
          chapter_area_references: chapter_area_references.paste
        )
      end

      def self.v3(book:, metadata_source:)
        V3.new.bake(book: book)

        chapter_area_references = book.chapters.references.cut

        section(
          book: book,
          metadata_source: metadata_source,
          chapter_area_references: chapter_area_references.paste
        )
      end

      def self.section(book:, metadata_source:, chapter_area_references:, plural: true)
        Kitchen::Directions::CompositePageContainer.v1(
          container_key: plural ? 'references' : 'reference',
          uuid_key: plural ? '.references' : '.reference',
          metadata_source: metadata_source,
          content: chapter_area_references,
          append_to: book.body
        )
      end
    end
  end
end
