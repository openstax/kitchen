# frozen_string_literal: true

module Kitchen::Directions::BakeExercises
  class V1
    renderable
    def bake(book:, class_name:, bake_eob:, bake_section_title:)
      metadata_elements = book.metadata.children_to_keep.copy

      solutions_clipboards = []

      book.chapters.each do |chapter|
        exercise_clipboard = Kitchen::Clipboard.new
        solution_clipboard = Kitchen::Clipboard.new
        solutions_clipboards.push(solution_clipboard)

        chapter.pages('$:not(.introduction)').each do |page|
          sections = page.exercises(class_name: class_name)

          sections.each do |exercise_section|
            exercise_section.first("[data-type='title']")&.trash
            bake_exercise_section_title(exercise_section: exercise_section, page: page, chapter: chapter) if bake_section_title

            exercise_section.exercises.each do |exercise|
              exercise.document.pantry(name: :link_text).store(
                "#{I18n.t(:exercise_label)} #{chapter.count_in(:book)}.#{exercise.count_in(:chapter)}",
                label: exercise.id
              )

              bake_exercise_in_place(exercise: exercise)
              next unless bake_eob

              exercise.solution&.cut(to: solution_clipboard)
            end

            exercise_section.cut(to: exercise_clipboard)
          end
        end

        next if exercise_clipboard.none?

        classname_title = class_name.sub('section.', '')
        chapter.append(child:
          <<~HTML
            <div class="os-eoc os-#{classname_title}-container" data-type="composite-page" data-uuid-key=".#{classname_title}">
              <h2 data-type="document-title">
                <span class="os-text">#{I18n.t(:eoc_exercises_title)}</span>
              </h2>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">#{I18n.t(:eoc_exercises_title)}</h1>
                #{metadata_elements.paste}
              </div>
              #{exercise_clipboard.paste}
            </div>
          HTML
        )
      end

      return unless bake_eob

      # Store a paste here to use at end so that uniquifyied IDs match legacy baking
      @eob_metadata = metadata_elements.paste
      @solutions = solutions_clipboards.map.with_index do |solution_clipboard, index|
        <<~HTML
          <div class="os-eob os-solution-container " data-type="composite-page" data-uuid-key=".solution#{index + 1}">
            <h2 data-type="document-title">
              <span class="os-text">#{I18n.t(:chapter)} #{index + 1}</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">#{I18n.t(:chapter)} #{index + 1}</h1>
              #{metadata_elements.paste}
            </div>
            #{solution_clipboard.paste}
          </div>
        HTML
      end

      return if @solutions.none?

      @solutions_classname = 'solution'
      book.first('body').append(child: render(file: 'eob.xhtml.erb'))
    end

    def bake_exercise_section_title(exercise_section:, chapter:, page:)
      exercise_section_title = page.title.copy
      exercise_section_title.name = 'h3'
      exercise_section_title.replace_children(with: <<~HTML
        <span class="os-number">#{chapter.count_in(:book)}.#{page.count_in(:chapter)}</span>
        <span class="os-divider"> </span>
        <span class="os-text" data-type="" itemprop="">#{exercise_section_title.children}</span>
      HTML
      )
      exercise_section.prepend(child:
        <<~HTML
          <a href="##{page.title.id}">
            #{exercise_section_title.paste}
          </a>
        HTML
      )
    end

    def bake_exercise_in_place(exercise:, bake_solution: true)
      # Bake an exercise in place going from:
      #
      # <div data-type="exercise" id="exerciseId">
      #   <div data-type="problem" id="problemId">
      #     Problem Content
      #   </div>
      #   <div data-type="solution" id="solutionId">
      #     Solution Content
      #   </div>
      # </div>
      #
      # to
      #
      # <div data-type="exercise" id="exerciseId" class="os-hasSolution">
      #   <div data-type="problem" id="problemId">
      #     <a class="os-number" href="#exerciseId-solution">1</a>
      #     <span class="os-divider">. </span>
      #     <div class="os-problem-container ">
      #       Problem Content
      #     </div>
      #   </div>
      #   <div data-type="solution" id="exerciseId-solution">
      #     <a class="os-number" href="#exerciseId">1</a>
      #     <span class="os-divider">. </span>
      #     <div class="os-solution-container ">
      #       Solution Content
      #     </div>
      #   </div>
      # </div>
      #
      # If there is no solution, don't add the 'os-hasSolution' class and don't
      # link the number.

      problem = exercise.problem
      solution = exercise.solution
      count_in = exercise.count_in(:chapter)
      problem_number = "<span class='os-number'>#{count_in}</span>"

      if solution.present? && bake_solution
        solution.id = "#{exercise.id}-solution"

        exercise.add_class('os-hasSolution')
        problem_number = "<a href='##{solution.id}' class='os-number'>#{count_in}</a>"

        solution.replace_children(with:
          <<~HTML
            <a class="os-number" href="##{exercise.id}">#{count_in}</a>
            <span class="os-divider">. </span>
            <div class="os-solution-container ">#{solution.children}</div>
          HTML
        )
      end

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
