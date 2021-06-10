# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeFootnotes
      def self.v1(book:)
        V1.new.bake(book: book)
      end

      def self.v2(book:)
        V2.new.bake(book: book)
      end

      def self.bake_footnotes_within(container, number_format: :arabic)
        footnote_count = 0
        aside_id_to_footnote_number = {}

        container.search("a[role='doc-noteref']").each do |anchor|
          footnote_count += 1
          footnote_number = footnote_count.to_format(number_format).to_s
          anchor.replace_children(with: footnote_number)
          aside_id = anchor[:href][1..-1]
          aside_id_to_footnote_number[aside_id] = footnote_number
          anchor.parent.add_class('has-noteref') if anchor.parent.name == 'p'
        end

        container.search('aside').each do |aside|
          footnote_number = aside_id_to_footnote_number[aside.id]
          aside.prepend(child: "<div data-type='footnote-number'>#{footnote_number}</div>")
        end

        footnote_count
      end
    end
  end
end
