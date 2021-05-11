# frozen_string_literal: true

module Kitchen
  module Directions
    module MoveSolutionsToAnswerKey
      def self.v1(chapter:, metadata_source:, strategy:, append_to:, klass: 'solutions')
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          strategy: strategy, append_to: append_to,
          klass: klass)
      end
    end
  end
end
