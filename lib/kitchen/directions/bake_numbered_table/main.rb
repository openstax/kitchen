# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNumberedTable
      def self.v1(table:, number:, always_caption: false)
        V1.new.bake(table: table, number: number, always_caption: always_caption)
      end
    end
  end
end
