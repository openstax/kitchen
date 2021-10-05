# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for EOB references
    #
    module BakeReferences
      def self.v1(book:, metadata_source:, numbered_title: false)
        V1.new.bake(book: book, numbered_title: numbered_title)

        chapter_area_references = book.chapters.search('.os-chapter-area').cut

        Kitchen::Directions::CompositePageContainer.v1(
          container_key: 'reference',
          uuid_key: '.reference',
          metadata_source: metadata_source,
          content: chapter_area_references.paste,
          append_to: book.body
        )
      end

      def self.v2(book:, metadata_source:)
        V2.new.bake(book: book)

        chapter_area_references = book.chapters.search('.os-chapter-area').cut

        Kitchen::Directions::CompositePageContainer.v1(
          container_key: 'references',
          uuid_key: '.references',
          metadata_source: metadata_source,
          content: chapter_area_references.paste,
          append_to: book.body
        )
      end

      def self.v3(book:, metadata_source:)
        V3.new.bake(book: book)

        chapter_area_references = book.chapters.references.cut

        Kitchen::Directions::CompositePageContainer.v1(
          container_key: 'references',
          uuid_key: '.references',
          metadata_source: metadata_source,
          content: chapter_area_references.paste,
          append_to: book.body
        )
      end
    end
  end
end
