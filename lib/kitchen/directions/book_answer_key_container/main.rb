# frozen_string_literal: true

module Kitchen
  module Directions
    module BookAnswerKeyContainer
      def self.v1(book:, klass: 'solutions')
        V1.new.bake(book: book, klass: klass)
      end
    end
  end
end
