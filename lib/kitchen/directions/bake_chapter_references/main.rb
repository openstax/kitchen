# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeChapterReferences
      def self.v1(chapter:, metadata_source:, uuid_prefix: '.', klass: 'references', from_introduction: false )
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          uuid_prefix: uuid_prefix,
          klass: klass,
          from_introduction: from_introduction
        )
      end
    end
  end
end
