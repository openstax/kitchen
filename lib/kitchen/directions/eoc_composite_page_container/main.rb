# frozen_string_literal: true

module Kitchen
  module Directions
    module EocCompositePageContainer
      def self.v1(container_key:, uuid_key:, metadata_source:, content:,
                  append_to: nil)
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
