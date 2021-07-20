# frozen_string_literal: true

# rubocop:disable Metrics/ParameterLists
# More parameters are ok here because these generic classes DRY up a lot of other code
module Kitchen
  module Directions
    module MoveCustomSectionToEobContainer
      # Creates a custom eob composite page for a section within the given book.
      # The sections are moved into this composite page, and can be transformed before the moved by an optional block argument.
      #
      # @param book [BookElement] the book in which the section to be moved will go at the end
      # @param metadata_source [MetadataElement] metadata for the book
      # @param container_key [String] Appended to 'eob.' to form the I18n key for the container title; also used as part of a class on the container.
      # @param uuid_key [String] the uuid key for the wrapper class, e.g. `'.summary'`
      # @param section_selector [String] the selector for the section to be moved, e.g. `'section.summary'`
      # @param append_to [ElementBase] the element to be appended. Defaults to the value of `book` param if none given.
      # @param include_intro_page [Boolean] control the introduction page for the chapter should be searched for a section to move, default is true
      # @return [ElementBase] the append_to element with container appended
      #
      def self.v1(book:, metadata_source:, container_key:, uuid_key:,
                  section_selector:, append_to: nil, include_intro_page: true)
        V1.new.bake(
          book: book,
          metadata_source: metadata_source,
          container_key: container_key,
          uuid_key: uuid_key,
          section_selector: section_selector,
          append_to: append_to || book.body,
          include_intro_page: include_intro_page
        ) do |section|
          yield section if block_given?
        end
      end
    end
  end
end
# rubocop:enable Metrics/ParameterLists
