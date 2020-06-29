module Kitchen
  module Directions
    module BakeAppendix

      def self.v1(page:, number:)
        title = page.title
        title.name = "h1"
        title.replace_children(with:
          <<~HTML
            <span class="os-part-text">#{I18n.t(:appendix)} </span>
            <span class="os-number">#{number}</span>
            <span class="os-divider"> </span>
            <span data-type="" itemprop="" class="os-text">#{title.children}</span>
          HTML
        )
      end

    end
  end
end