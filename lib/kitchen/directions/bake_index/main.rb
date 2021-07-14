# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeIndex
      def self.v1(book:, types:, uuid_prefix: nil)
        V1.new.bake(book: book, types: types, uuid_prefix: uuid_prefix)
      end

      def self.v2(book:, types:)
        V2.new.bake(book: book, types: types)
      end
    end
  end
end
