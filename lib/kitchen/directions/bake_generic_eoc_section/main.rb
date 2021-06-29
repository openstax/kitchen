# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeGenericEocSection
      def self.v1(chapter:, metadata_source:, klass:, append_to: nil, uuid_prefix: '.',
                  include_intro: true)
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          append_to: append_to,
          klass: klass,
          uuid_prefix: uuid_prefix,
          include_intro: include_intro
        ) do |section|
          yield section if block_given?
        end
      end
    end
  end
end