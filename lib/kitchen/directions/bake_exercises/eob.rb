# frozen_string_literal: true

module Kitchen::Directions::BakeExercises
  class EOB
    renderable

    def bake(book:, class_names:)
      @metadata_elements = book.metadata.children_to_keep.copy

      @composite_chapter_number = book.search('.os-toc-chapter ol.os-chapter').count + 1
      # Store a paste here to use at end so that uniquifyied IDs match legacy baking
      @eob_metadata = @metadata_elements.paste
      book.first('body').append(child: render(file: 'v1.xhtml.erb'))

      book.chapters.each do |chapter|
        @solutions = []
        chapter_counter = 0
        class_names.each do |key, config|
          section_title = I18n.t(key)
          solution_clipboard = Kitchen::Clipboard.new
          chapter.search(config[:classname]).each_with_index do |exercise_section, index|
            @index = index
            exercise_section.search("[data-element-type='hint']").each(&:trash)

            exercise_section.exercises.each do |exercise|
              problem = exercise.problem
              solution = exercise.solution

              number = config[:decimal] ? "#{chapter.count_in(:book)}.#{exercise.count_in(:chapter)}" : chapter_counter += 1
              problem.first('.os-number')&.inner_html = number.to_s
              next unless solution.present?

              solution.id = "#{exercise.id}-solution"
              solution.first('.os-number')&.inner_html = number.to_s
              solution&.cut(to: solution_clipboard)
            end
            next unless config[:sectional]

            # append hash for exercise sections and clear clipboard
            section_title = I18n.t(:section_exercises, number: "#{chapter.count_in(:book)}.#{exercise_section.count_in(:chapter)}")
            @solutions.push({ section_title => solution_clipboard.paste })
            solution_clipboard.clear
          end
          next if config[:sectional]

          @solutions.push({ section_title => solution_clipboard.paste })
        end
        book.first('.os-eob.os-solutions-container').append(child: render(file: 'solutions.xhtml.erb'))
      end
    end
  end
end
