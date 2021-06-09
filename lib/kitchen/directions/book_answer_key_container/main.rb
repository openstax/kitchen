# frozen_string_literal: true

module Kitchen
  module Directions
    module BookAnswerKeyContainer
      def self.v1(book:)
        V1.new.bake(book: book)
      end

      def self.v2(book:)
        V2.new.bake(book: book)
      end
    end
  end
end
