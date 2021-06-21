# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for EOC suggested reading
    #
    module BakeFurtherReading
      def self.v1(book:)
        book.chapters.each do |chapter|
          # further_reading = chapter.pages.search('section.further-reading').cut
          further_reading = Clipboard.new

          chapter.search('section.further-reading').each do |section|
            section.search('h3').cut
            section.cut(to: further_reading)
          end

          chapter.append(child:
            <<~HTML
              <div class="os-eoc os-suggested-reading-container" data-type="composite-page" data-uuid-key=".suggested-reading">
                <h2 data-type="document-title">
                  <span class="os-text">#{I18n.t(:eoc_further_reading)}</span>
                </h2>
                #{further_reading.paste}
              </div>
            HTML
          )
        end
      end
    end
  end
end
