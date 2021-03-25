# frozen_string_literal: true

module Kitchen::Directions::BakeChapterReviewExercises
  class V1
    renderable

    def bake(chapter:, metadata_source:, append_to:)
      @metadata = metadata_source
      @exercise_clipboard = Kitchen::Clipboard.new

      chapter.non_introduction_pages.each do |page|
        sections = page.exercises(class_name: 'section.review-exercises')

        sections.each do |exercise_section|
          exercise_section.first("[data-type='title']")&.trash
          # bake_exercise_section_title(exercise_section: exercise_section, page: page, chapter: chapter) if bake_section_title

          exercise_section.exercises.each do |exercise|
            exercise.document.pantry(name: :link_text).store(
              "#{I18n.t(:exercise_label)} #{chapter.count_in(:book)}.#{exercise.count_in(:chapter)}",
              label: exercise.id
            )

            bake_exercise_in_place(exercise: exercise)
          end

          # exercise_section.cut(to: @exercise_clipboard)
        end
      end

      return if @exercise_clipboard.none?

      append_to.append(child: render(file: 'review_exercises.xhtml.erb'))
    end

    def bake_exercise_in_place(exercise:)
      problem = exercise.problem
      count_in = exercise.count_in(:chapter)
      problem_number = "<span class='os-number'>#{count_in}</span>"

      # if solution.present? && bake_solution
      #   solution.id = "#{exercise.id}-solution"

      #   exercise.add_class('os-hasSolution')
      #   problem_number = "<a href='##{solution.id}' class='os-number'>#{count_in}</a>"

      #   solution.replace_children(with:
      #     <<~HTML
      #       <a class="os-number" href="##{exercise.id}">#{count_in}</a>
      #       <span class="os-divider">. </span>
      #       <div class="os-solution-container ">#{solution.children}</div>
      #     HTML
      #   )
      # end

      problem.replace_children(with:
        <<~HTML
          #{problem_number}
          <span class="os-divider">. </span>
          <div class="os-problem-container ">#{problem.children}</div>
        HTML
      )
    end
  end
end

