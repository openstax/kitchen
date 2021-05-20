# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsToAnswerKey
  module Strategies
    class Sociology
      def bake(chapter:, append_to:)
        bake_section(chapter: chapter, append_to: append_to, klass: 'section-quiz')
      end

      protected

      def bake_section(chapter:, append_to:, klass:)
        chapter.search(".#{klass} [data-type='solution']").each do |solution|
          next unless solution.present?

          append_to.add_child(solution.cut.to_s)
        end
      end
    end
  end
end
