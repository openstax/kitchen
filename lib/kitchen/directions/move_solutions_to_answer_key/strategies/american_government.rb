# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsToAnswerKey
  module Strategies
    class AmericanGovernment
      def bake(chapter:, append_to:)
        bake_section(chapter: chapter, append_to: append_to, klass: 'review-questions')
      end

      protected

      def bake_section(chapter:, append_to:, klass:)
        section_solutions_set = chapter.search(".#{klass} [data-type='solution']").map(&:cut)
        section_solutions_set.map { |solution| append_to.add_child(solution.raw) }
      end
    end
  end
end
