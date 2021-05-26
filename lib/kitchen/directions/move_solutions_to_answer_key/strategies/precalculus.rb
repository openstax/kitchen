# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsToAnswerKey
  module Strategies
    class Precalculus
      def bake(chapter:, append_to:)
        bake_try_note(chapter: chapter, append_to: append_to)

        # Bake section exercises
        chapter.non_introduction_pages.each do |page|
          number = "#{chapter.count_in(:book)}.#{page.count_in(:chapter)}"
          bake_section(chapter: page, append_to: append_to, klass: 'section-exercises',
                       number: number)
        end

        # Bake other types of exercises
        classes = %w[review-exercises practice-test]
        classes.each do |klass|
          bake_section(chapter: chapter, append_to: append_to, klass: klass)
        end
      end

      protected

      def bake_section(chapter:, append_to:, klass:, number: nil)
        section_solutions_set = []
        chapter.search(".#{klass}").each do |section|
          section.search('[data-type="solution"]').each do |solution|
            section_solutions_set.push(solution.cut)
          end
        end

        return if section_solutions_set.empty?

        title = <<~HTML
          <h3 data-type="title">
            <span class="os-title-label">#{I18n.t(:"eoc.#{klass}", number: number)}</span>
          </h3>
        HTML

        append_solution_area(title: title, solutions: section_solutions_set, append_to: append_to)
      end

      def bake_try_note(chapter:, append_to:)
        append_to.add_child(
          <<~HTML
            <div class="os-module-reset-solution-area os-try-solution-area">
              <h3 data-type="title">
                <span class="os-title-label">#{I18n.t(:"notes.try")}</span>
              </h3>
            </div>
          HTML
        )
        chapter.non_introduction_pages.each do |page|
          solutions = []
          page.notes('$.try').each do |note|
            note.exercises.each do |exercise|
              solution = exercise.solution
              solutions.push(solution.cut) if solution
            end
          end
          next if solutions.empty?

          title_snippet = Kitchen::Directions::EocSectionTitleLinkSnippet.v2(page: page)

          append_solution_area(title: title_snippet, solutions: solutions,
                               append_to: append_to.search('.os-try-solution-area').first)
        end
      end

      def append_solution_area(title:, solutions:, append_to:)
        append_to = append_to.add_child(
          <<~HTML
            <div class="os-solution-area">
              #{title}
            </div>
          HTML
        ).first

        solutions.each do |solution|
          append_to.add_child(solution.raw)
        end
      end
    end
  end
end
