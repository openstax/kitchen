# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeCustomSections
      def self.v1(chapter:, property_classes:, inject:, text:)
        V1.new.bake(
          chapter: chapter,
          property_classes: property_classes,
          inject: inject,
          text: text)
      end
    end
  end
end
