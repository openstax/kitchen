# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeFirstElements
      def self.v1(within:)
        selectors = [
          '.os-problem-container > .os-table',
          '.os-problem-container > [data-type="media"]',
          '.os-solution-container > .os-table',
          '.os-solution-container > [data-type="media"]'
        ]
        selectors.each do |selector|
          within.search("#{selector}:first-child").each do |problem|
            problem.add_class('first-element')
            problem.parent.add_class('has-first-element')
          end
        end
      end
    end
  end
end
