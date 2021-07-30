# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeCustomSections
      def self.v1(chapter:)
        V1.new.bake(chapter: chapter)
      end
    end
  end
end
