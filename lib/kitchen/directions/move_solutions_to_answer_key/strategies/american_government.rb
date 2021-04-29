# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsToAnswerKey
  module Strategies
    class AmericanGovernment
      def bake(chapter:, append_to:)
        bake_section(chapter: chapter, append_to: append_to, klass: 'review-questions')
      end

      protected

      def bake_section(chapter:, append_to:, klass:)
        section_solutions_set = []
        chapter.search(".#{klass}").each do |section|
          section.search('[data-type="solution"]').each do |solution|
            section_solutions_set.push(solution.cut)
          end
        end

        append_solution_area(section_solutions_set, append_to)
      end

      def append_solution_area(solutions, append_to)
        solutions.each do |solution|
          append_to.add_child(solution.raw)
        end
      end
    end
  end
end
