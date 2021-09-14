# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeUnnumberedFigures
      def self.v1(book:)
        book.figures('$.unnumbered').each do |figure|
          next unless figure.caption

          figure.wrap(%(<div class="os-figure#{' has-splash' if figure.has_class?('splash')}">))

          caption = figure.caption&.cut
          figure.append(sibling:
            <<~HTML
              <div class="os-caption-container">
                #{"<span class=\"os-caption\">#{caption.children}</span>" if caption}
              </div>
            HTML
          )
        end
      end
    end
  end
end
