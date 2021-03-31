# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeExample
      def self.v1(example:, number:, title_tag:)
        example.wrap_children(class: 'body')

        example.prepend(child:
          <<~HTML
            <#{title_tag} class="os-title">
              <span class="os-title-label">#{I18n.t(:example_label)} </span>
              <span class="os-number">#{number}</span>
              <span class="os-divider"> </span>
            </#{title_tag}>
          HTML
        )

        example.document
               .pantry(name: :link_text)
               .store("#{I18n.t(:example_label)} #{number}", label: example.id)

        example.titles.each { |title| title.name = 'h4' }

        example.exercises.each do |exercise|
          if (problem = exercise.problem)
            problem.titles.each { |title| title.name = 'h4' }
            problem.replace_children(with:
              <<~HTML
                <div class="os-problem-container ">#{problem.children}</div>
              HTML
            )
          end

          if (solution = exercise.solution)
            solution.replace_children(with:
              <<~HTML
                <h4 data-type="solution-title">
                  <span class="os-title-label">#{I18n.t(:solution)} </span>
                </h4>
                <div class="os-solution-container ">#{solution.children}</div>
              HTML
            )
          end

          exercise.add_class('unnumbered')
        end
      end
    end
  end
end
