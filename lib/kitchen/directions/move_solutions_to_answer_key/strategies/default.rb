# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsToAnswerKey
  module Strategies
    class Default
      def bake(chapter:, append_to:, klasses:)
        bake_section(chapter: chapter, append_to: append_to, klasses: klasses)
      end

      protected

      def bake_section(chapter:, append_to:, klasses:)
        klasses.each do |klass|
          chapter.search(".#{klass} [data-type='solution']").each do |solution|
            append_to.add_child(solution.cut.to_s)
          end
        end
      end
    end
  end
end
