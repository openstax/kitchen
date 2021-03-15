# frozen_string_literal: true

module Kitchen::Directions::BakeExercises
  # Bake directions for exercises
  class V3
    renderable

    def bake(book:, class_names:)
      @metadata_elements = book.metadata.search(%w(.authors .publishers .print-style
                                                  .permissions [data-type='subject'])).copy

      @composite_chapter_number = book.search('.os-toc-chapter ol.os-chapter').count + 1
      # Store a paste here to use at end so that uniquifyied IDs match legacy baking
      @eob_metadata = @metadata_elements.paste
      book.first('body').append(child: render(file: 'v1.xhtml.erb'))

      book.chapters.each do |chapter|
        @solutions = []
        class_names.each do |key, classname|
          section_title = I18n.t(key)
          solution_clipboard = Kitchen::Clipboard.new
          chapter.search(classname).each_with_index do |exercise_section, index|
            @index = index
            exercise_section.search("[data-element-type='hint']").each(&:trash)

            exercise_section.search("[data-type='exercise']").each do |exercise|
              problem = exercise.first("[data-type='problem']")
              solution = exercise.first("[data-type='solution']")
              next unless solution.present?

              solution.id = "#{exercise.id}-solution"
              number = classname.eql?('.checkpoint') ? "#{chapter.count_in(:book)}.#{exercise.count_in(:chapter)}" : exercise.count_in(:chapter)

              number = <<~HTML
                #{number}
              HTML
              problem.first('.os-number')&.replace_children(with: number)
              solution.first('.os-number').replace_children(with: number)
              solution&.cut(to: solution_clipboard)
            end
            next unless classname.eql?('section.section-exercises')

            # append hash for exercise sections and clear clipboard
            section_title = I18n.t(:section_exercises, number: "#{chapter.count_in(:book)}.#{exercise_section.count_in(:chapter)}")
            @solutions.push({ section_title => solution_clipboard.paste })
            solution_clipboard.clear
          end
          next if classname.eql?('section.section-exercises')

          @solutions.push({ section_title => solution_clipboard.paste })
        end
        book.first('.os-eob.os-solutions-container').append(child: render(file: 'solutions.xhtml.erb'))
      end
    end
  end
end
