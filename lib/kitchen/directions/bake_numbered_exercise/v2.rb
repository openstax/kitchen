# frozen_string_literal: true

# The main difference between V1 is that in this version prefixes for exercises are added during baking
module Kitchen::Directions::BakeNumberedExercise
  class V2
    def bake(exercise:, number:, cases:, prefix:)
      problem = exercise.problem
      solution = exercise.solution

      # Store label information
      label_number = "#{exercise.ancestor(:chapter).count_in(:book)}.#{number}"
      problem_divider = "<span class='os-divider'>. </span>"

      exercise.target_label(label_text: 'exercise', custom_content: label_number, cases: cases)

      problem_number = "<span class='os-number'>#{number}</span>"
      exercise_prefix = "<span class='os-number'>#{prefix}</span>"

      if solution.present?
        problem_number = \
          "<a class='os-number' href='##{exercise.id}-solution'>#{number}</a>"
        bake_solution(
          exercise: exercise,
          number: number
        )
      end

      problem.replace_children(with:
        <<~HTML
          #{exercise_prefix if exercise_prefix.present?}
          #{problem_number}
          #{problem_divider}
          <div class="os-problem-container">#{problem.children}</div>
        HTML
      )
    end

    def bake_solution(exercise:, number:, divider: '. ')
      solution = exercise.solution

      solution.id = "#{exercise.id}-solution"
      exercise.add_class('os-hasSolution')

      solution.replace_children(with:
        <<~HTML
          <span class='os-number'>#{prefix}</span>
          <a class='os-number' href='##{exercise.id}'>#{number}</a>
          <span class='os-divider'>#{divider}</span>
          <div class="os-solution-container">#{solution.children}</div>
        HTML
      )
    end
  end
end
