# frozen_string_literal: true

module Kitchen
  module Directions
    module EocCompositePageContainer
      def self.v1(metadata_source:, klass:, content:, append_to: nil, uuid_prefix: '.')
        V1.new.bake(
          metadata_source: metadata_source,
          append_to: append_to,
          content: content,
          klass: klass,
          uuid_prefix: uuid_prefix
        )
      end
    end
  end
end
