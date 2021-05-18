# frozen_string_literal: true

module Kitchen::Directions::BakeOddNumberedExercise
  class V1
    def bake(composite_page:)
      section_exercises_set = []
      divider = '. '
      composite_page.search('.section-quiz [data-type = "exercise"]').each do |exercise|
        section_exercises_set.push(exercise.cut)
        @number = exercise.count_in(:composite_page)
      end
      return if section_exercises_set.empty?

      odd_exercises_set = []
      odd_exercises_set = section_exercises_set.values_at(*section_exercises_set.each_index.select{|i| i.even?})
      return if odd_exercises_set.empty?

      odd_exercises_set.each do |exercise|
          problem_number = "<a class='os-number' href='##{exercise.id}-solution'>#{@number}</a>"
          exercise.search("[data-type='problem']").each do |problem|
            problem.replace_children(with:
              <<~HTML
                #{problem_number}
                <span class='os-divider'>. </span>
                <div class="os-problem-container">#{problem.children}</div>
              HTML
            )
          end
          exercise.search('[data-type = "solution"]').each do |solution|
            solution.id = "#{exercise.id}-solution"
            exercise.add_class('os-hasSolution')
            solution.replace_children(with:
              <<~HTML
                <a class='os-number' href='##{exercise.id}'>#{@number}</a>
                <span class='os-divider'>#{divider}</span>
                <div class="os-solution-container">#{solution.children}</div>
              HTML
            )
        end
      end

      even_exercises_set = []
      even_exercises_set = section_exercises_set.values_at(*section_exercises_set.each_index.select{|i| i.odd?})
      even_exercises_set.each do |exercise|
        exercise.add_class('os-hasSolution-trashed')
        exercise.search("[data-type='problem']").each do |problem|
          problem.replace_children(with:
            <<~HTML
              <span class='os-number'>#{@number}</span>
              <span class='os-divider'>. </span>
              <div class="os-problem-container">#{problem.children}</div>
            HTML
          )
          end

        exercise.search('[data-type = "solution"]').each do |solution|
          solution.trash
        end

      end
    end
  end
end
