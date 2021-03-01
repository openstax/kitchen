module Kitchen
  module Directions
    module BakeFigure
      def self.v1(figure:, number:, caption_selector: 'figcaption')
        figure.wrap(%(<div class="os-figure#{' has-splash' if figure.has_class?('splash')}">))

        figure.document.pantry(name: :link_text).store "#{I18n.t(:figure)} #{number}", label: figure.id

        caption = figure.caption(classname: caption_selector)&.cut
        figure.append(sibling:
          <<~HTML
            <div class="os-caption-container">
              <span class="os-title-label">#{I18n.t(:figure)} </span>
              <span class="os-number">#{number}</span>
              <span class="os-divider"> </span>
              <span class="os-divider"> </span>
              #{'<span class="os-caption">' + caption.children.to_s + '</span>' if caption}
            </div>
          HTML
        )
      end
    end
  end
end
