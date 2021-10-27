# frozen_string_literal: true

module Kitchen
  module Directions
    module MoveSolutionsToAnswerKey
      def self.v1(
        chapter:, metadata_source:, append_to:, solutions_plural: true
      )
        AnswerKeyInnerContainer.v1(
          chapter: chapter,
          metadata_source: metadata_source,
          append_to: append_to,
          solutions_plural: solutions_plural
        )
      end
    end
  end
end
