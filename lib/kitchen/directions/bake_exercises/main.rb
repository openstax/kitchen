# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeExercises
      def self.v1(book:, class_name: 'section.exercises', bake_eob: true, bake_section_title: true)
        V1.new.bake(book: book, class_name: class_name, bake_eob: bake_eob, bake_section_title: bake_section_title)
      end
    end
  end
end
