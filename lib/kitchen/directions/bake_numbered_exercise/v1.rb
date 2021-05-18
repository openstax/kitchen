# frozen_string_literal: true

module Kitchen::Directions::BakeNumberedExercise
  class V1
    def bake(exercise:, number:, suppress_solution: false, suppress_even_solution: false)
      problem = exercise.problem
      solution = exercise.solution
      problem_number = "<span class='os-number'>#{number}</span>"

      if solution.present?
        if suppress_solution
          solution.trash
        elsif suppress_even_solution && number.odd?
            # section_exercises_set = []
            # section_exercises_set.push(exercise.cut)
            # odd_exercises_set = []
            # odd_exercises_set = section_exercises_set.values_at(*section_exercises_set.each_index.select{|i| i.even?})
            # odd_exercises_set.each do |odd_exercise|
            # end
          problem_number = "<a class='os-number' href='##{exercise.id}-solution'>#{number}</a>"
          bake_solution(exercise: exercise, number: number)
        elsif suppress_even_solution && number.even?
          problem_number = "<span class='os-number'>#{number}</span>"
          bake_even_solution(exercise: exercise, number: number)
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

    def bake_even_solution(exercise:, number:, divider: '. ')
      solution = exercise.solution
      solution.id = "#{exercise.id}-solution"
      exercise.add_class('os-hasSolution-trashed')

      # solution.replace_children(with:
      #   <<~HTML
      #     <a class='os-number' href='##{exercise.id}'>#{number}</a>
      #     <span class='os-divider'>#{divider}</span>
      #     <div class="os-solution-container">#{solution.children}</div>
      #   HTML
      # )
      solution.trash
    end

    # def bake_odd_solution(exercise:, number:, divider: '. ')
    #   section_exercises_set = []
    #   section_exercises_set.push(exercise.cut)

    #   odd_exercises_set = []
    #   odd_exercises_set = section_exercises_set.values_at(*section_exercises_set.each_index.select{|i| i.even?})

    #   return if odd_exercises_set.empty?

    #   odd_exercises_set.each do |odd_exercise|
    #     odd_solution = odd_exercise.solution
    #     odd_solution.id = "#{odd_exercise.id}-solution"
    #     odd_exercise.add_class('os-hasSolution')
    #     odd_solution.replace_children(with:
    #       <<~HTML
    #         <a class='os-number' href='##{odd_exercise.id}'>#{number}</a>
    #         <span class='os-divider'>#{divider}</span>
    #         <div class="os-solution-container">#{odd_solution.children}</div>
    #       HTML
    #     )

    #   end

    #   even_exercises_set = []
    #   even_exercises_set = section_exercises_set.values_at(*section_exercises_set.each_index.select{|i| i.odd?})
    #   even_exercises_set.each do |even_exercise|
    #     even_exercise.add_class('os-hasSolution-trashed')
    #     even_exercise.problem.replace_children(with:
    #       <<~HTML
    #         <span class='os-number'>#{number}</span>
    #         <span class='os-divider'>. </span>
    #         <div class="os-problem-container">#{problem.children}</div>
    #       HTML
    #     )
    #     even_solution = even_exercise.solution
    #     even_solution.trash
    #   end
    # end
  end
end
