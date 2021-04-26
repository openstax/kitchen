module Kitchen
  module Directions
    module BakeFreeResponse
      def self.v1(book:)
        V1.new.bake(book: book)
      end
    end
  end
end
