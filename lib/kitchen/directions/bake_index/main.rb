# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeIndex
      def self.v1(book:)
        V1.new.bake(book: book)
      end

      def self.v2(book:, type:)
        V2.new.bake(book: book, type: type)
      end
    end
  end
end
