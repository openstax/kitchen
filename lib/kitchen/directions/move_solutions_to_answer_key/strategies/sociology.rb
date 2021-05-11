module Kitchen::Directions::MoveSolutionsToAnswerKey
  module Strategies
    class Sociology
      def bake(chapter:, append_to:)
        bake_section(chapter: chapter, append_to: append_to, klass: 'section-quiz')
      end

      protected

      def bake_section(chapter:, append_to:, klass:)
        section_solutions_set = []
        chapter.search(".#{klass} [data-type='solution']").each do |solution|
          section_solutions_set.push(solution.cut)
        end

        even_solutions_set = []
        # even_solutions_set = section_solutions_set.select{|solution| solution.odd?}
        # even_solutions_set = section_solutions_set.values_at(*self.each_index.select(&:even?))
        even_solutions_set = section_solutions_set.values_at(*section_solutions_set.each_index.select{|i| i.even?})

        # return if section_solutions_set.empty?
        return if even_solutions_set.empty?

        # append_to.add_child(section_solutions_set.cut.to_s)
        # append_to.add_child(even_solutions_set.cut)
        even_solutions_set.each do |solution|
          append_to.add_child(solution.raw)
        end
      end

      # append_solution_area(section_solutions_set, append_to)

      # def append_solution_area(title, solutions, append_to)
      #   append_to = append_to.add_child(
      #     <<~HTML
      #       <div class="os-solution-area">
      #         <h3 data-type="title">
      #           <span class="os-title-label">#{title}</span>
      #         </h3>
      #       </div>
      #     HTML
      #   ).first

      #   solutions.each do |solution|
      #     append_to.add_child(solution.raw)
      #   end
      # end
    end
  end
end
