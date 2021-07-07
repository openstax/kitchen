# frozen_string_literal: true

module Kitchen
  module Directions
    module EocCompositePageContainer
      # Creates a wrapper for the given content & appends it to the given element
      #
      # @param container_key [String] both the lookup key for the container title & part of the wrapper class name, e.g. `'summary'`
      # @param uuid_key [String] the uuid key for the wrapper class, e.g. `'.summary'`
      # @param metadata_source [MetadataElement] metadata for the book
      # @param content [String] the content to be contained by the wrapper
      # @param append_to [KitchenElement] the element to be appended, usually either a `ChapterElement` or a `CompositeChapterElement`
      # @return [KitchenElement] the append_to element with container appended
      def self.v1(container_key:, uuid_key:, metadata_source:, content:,
                  append_to:)
        V1.new.bake(
          container_key: container_key,
          uuid_key: uuid_key,
          metadata_source: metadata_source,
          content: content,
          append_to: append_to
        )
      end
    end
  end
end
