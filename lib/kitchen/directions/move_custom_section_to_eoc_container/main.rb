# frozen_string_literal: true

# rubocop:disable Metrics/ParameterLists
# More parameters are ok here because these generic classes DRY up a lot of other code
module Kitchen
  module Directions
    module MoveCustomSectionToEocContainer
      def self.v1(chapter:, metadata_source:, klass:, append_to: nil, uuid_prefix: '.',
                  include_intro_page: true)
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          append_to: append_to,
          klass: klass,
          uuid_prefix: uuid_prefix,
          include_intro_page: include_intro_page
        ) do |section|
          yield section if block_given?
        end
      end
    end
  end
end
# rubocop:enable Metrics/ParameterLists
