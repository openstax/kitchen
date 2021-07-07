# frozen_string_literal: true

# rubocop:disable Metrics/ParameterLists
# More parameters are ok here because these generic classes DRY up a lot of other code
module Kitchen
  module Directions
    module MoveCustomSectionToEocContainer
      def self.v1(chapter:, metadata_source:, container_key:, uuid_key:,
                  section_selector:, append_to: nil, include_intro_page: true)
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          container_key: container_key,
          uuid_key: uuid_key,
          section_selector: section_selector,
          append_to: append_to || chapter,
          include_intro_page: include_intro_page
        ) do |section|
          yield section if block_given?
        end
      end
    end
  end
end
# rubocop:enable Metrics/ParameterLists
