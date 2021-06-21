# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeGenericEocSection
      def self.v1(chapter:, metadata_source:, klass:, append_to: nil, uuid_prefix: '.',
                  content_transform: [])
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          append_to: append_to,
          klass: klass,
          uuid_prefix: uuid_prefix,
          content_transform: content_transform
        )
      end
    end
  end
end
