# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeCheckpoint
      def self.v1(checkpoint:, number:)
        checkpoint.replace_children(with:
          <<~HTML
            <div class="os-note-body">#{checkpoint.children}</div>
          HTML
        )

        checkpoint.prepend(child:
          <<~HTML
            <div class="os-title">
              <span class="os-title-label">#{I18n.t(:checkpoint)} </span>
              <span class="os-number">#{number}</span>
              <span class="os-divider"> </span>
            </div>
          HTML
        )

        exercise = checkpoint.exercises.first!
        exercise.add_class('unnumbered')
        exercise.search("[data-type='commentary']").trash

        problem = exercise.problem
        problem.replace_children(with:
          <<~HTML
            <div class="os-problem-container">#{problem.children}</div>
          HTML
        )

        solution = exercise.solution
        return unless solution.present?

        solution.id = "#{exercise.id}-solution"
        exercise.add_class('os-hasSolution')

        solution.replace_children(with:
          <<~HTML
            <span class="os-divider"> </span>
            <a class="os-number" href="##{exercise.id}">#{number}</a>
            <div class="os-solution-container">#{solution.children}</div>
          HTML
        )
      end
    end
  end
end
