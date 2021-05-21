# frozen_string_literal: true

module Kitchen::Directions::BakeNumberedExercise
  class V1
    def bake(exercise:, number:, suppress_solution: false, suppress_even_solution: false)
      problem = exercise.problem
      solution = exercise.solution

      exercise.pantry(name: :link_text).store(
        "#{I18n.t(:exercise_label)} #{exercise.ancestor(:chapter).count_in(:book)}.#{number}",
        label: exercise.id
      )
      problem_number = "<span class='os-number'>#{number}</span>"

      if solution.present?
        if suppress_solution
          solution.trash
        elsif suppress_even_solution && number.odd?
          problem_number = "<a class='os-number' href='##{exercise.id}-solution'>#{number}</a>"
          bake_solution(exercise: exercise, number: number)
        elsif suppress_even_solution && number.even?
          problem_number = "<span class='os-number'>#{number}</span>"
          bake_even_solution(exercise: exercise)
        else
          problem_number = "<a class='os-number' href='##{exercise.id}-solution'>#{number}</a>"
          bake_solution(exercise: exercise, number: number)
        end
      end

      problem.replace_children(with:
        <<~HTML
          #{problem_number}
          <span class='os-divider'>. </span>
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
          <a class='os-number' href='##{exercise.id}'>#{number}</a>
          <span class='os-divider'>#{divider}</span>
          <div class="os-solution-container">#{solution.children}</div>
        HTML
      )
    end

    def bake_even_solution(exercise:)
      solution = exercise.solution
      solution.id = "#{exercise.id}-solution"
      exercise.add_class('os-hasSolution-trashed')
      solution.trash
    end
  end
end
