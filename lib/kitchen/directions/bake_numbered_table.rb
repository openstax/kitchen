module Kitchen
  module Directions
    module BakeNumberedTable

      def self.v1(table:, number:)
        table.wrap(%Q(<div class="os-table">))

        table_label = "#{I18n.t(:table)} #{number}"
        table.document.pantry(name: :link_text).store "#{I18n.t(:table)} #{number}", label: table.id

        if table.top_titled?
          table.prepend(sibling:
            <<~HTML
              <div class="os-table-title">#{table.title}</div>
            HTML
          )
          table.title_row.trash
        end

        # TODO extra spaces added here to match legacy implementation, but probably not meaningful?
        table[:summary] = "#{I18n.t(:table)} #{number}" + "  "

        if !table.unnumbered?
          table.append(sibling:
            <<~HTML
              <div class="os-caption-container">
                <span class="os-title-label">#{I18n.t(:table)} </span>
                <span class="os-number">#{number}</span>
                <span class="os-divider"> </span>
                <span class="os-divider"> </span>
              </div>
            HTML
          )
        end
      end

    end
  end
end