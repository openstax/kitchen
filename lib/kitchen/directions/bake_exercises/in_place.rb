# frozen_string_literal: true

module Kitchen::Directions::BakeExercises
  class InPlace
    def note_exercises(exercise:)
      problem = exercise.first("[data-type='problem']")
      solution = exercise.first("[data-type='solution']")

      if solution.present?
        solution.id = "#{exercise.id}-solution"
        exercise.add_class('os-hasSolution unnumbered')
      end

      problem.replace_children(with:
        <<~HTML
          <div class="os-problem-container ">#{problem.children}</div>
        HTML
      )
    end

    def section_exercises(exercise:, number:)
      problem = exercise.problem
      solution = exercise.solution

      problem_number = "<span class='os-number'>#{number}</span><span class='os-divider'>. </span>"
      if solution.present?
        exercise.add_class('os-hasSolution')
        problem_number = "<a class='os-number' href='##{exercise.id}-solution'>#{number}</a>
          <span class='os-divider'>. </span>"
        solution.replace_children(with:
          <<~HTML
            <a class='os-number' href='##{exercise.id}'>#{number}</a>
            <span class='os-divider'>. </span>
            <div class="os-solution-container ">#{solution.children}</div>
          HTML
        )
      end

      problem.replace_children(with:
        <<~HTML
          #{problem_number}
          <div class="os-problem-container">#{problem.children}</div>
        HTML
      )
    end
  end
end
