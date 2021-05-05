# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeIndex
      def self.v1(book:, type: nil)
        V1.new.bake(book: book, type: type)
      end
    end
  end
end
