# frozen_string_literal: true

module Kitchen::Directions::BakeExercises
  class InPlace
    def example_exercises(exercise:)
      problem = exercise.problem
      solution = exercise.solution
      #count_in = exercise.count_in(:chapter)

      #problem_number = "<span class='os-number'>#{count_in}</span>"

      if solution.present?
        # solution.id = "#{exercise.id}-solution"

        exercise.add_class('unnumbered')
        #problem_number = "<a href='##{solution.id}' class='os-number' >#{exercise.count_in(:chapter)}</a>"

        solution.replace_children(with:
          <<~HTML
            <h4 data-type="solution-title">
              <span class="os-title-label">Solution </span>
            </h4>
            <div class="os-solution-container ">#{solution.children}</div>
          HTML
        )
      end

      problem.search('div[data-type="title"]').each { |title| title.name = 'h4' }
      problem.replace_children(with:
        <<~HTML
          <div class="os-problem-container ">#{problem.children}</div>
        HTML
      )
    end

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
