module Kitchen
  module Directions
    module BakeFootnotes

      def self.v1(book:)
        V1.new.bake(book: book)
      end

    end
  end
end