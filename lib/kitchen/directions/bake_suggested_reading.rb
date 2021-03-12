# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for EOC suggested reading
    #
    module BakeSuggestedReading
      def self.v1(book:)
        book.chapters.each do |chapter|
          suggested_reading = chapter.search('section.suggested-reading')

          chapter.append(child:
            <<~HTML
              <div class="os-eoc os-suggested-reading-container" data-type="composite-page" data-uuid-key=".suggested-reading">
                <h2 data-type="document-title">
                  <span class="os-text">Suggestions for Further Study</span>
                </h2>
                #{suggested_reading}
              </div>
            HTML
          )
        end
      end
    end
  end
end
