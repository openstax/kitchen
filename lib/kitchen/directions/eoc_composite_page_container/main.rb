# frozen_string_literal: true

# rubocop:disable Metrics/ParameterLists
# More parameters are ok here because these generic classes DRY up a lot of other code
module Kitchen
  module Directions
    module EocCompositePageContainer
      def self.v1(title_key:, uuid_key:, container_class_type:, metadata_source:, content:,
                  append_to: nil)
        V1.new.bake(
          title_key: title_key,
          uuid_key: uuid_key,
          container_class_type: container_class_type,
          metadata_source: metadata_source,
          content: content,
          append_to: append_to
        )
      end
    end
  end
end
# rubocop:enable Metrics/ParameterLists
