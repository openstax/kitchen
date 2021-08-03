# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for table body
    #
    module BakeTableBody
      def self.v1(table:, number:, cases: false)
        table.remove_attribute('summary')
        table.wrap(%(<div class="os-table">))

        # Store label information
        table.target_label(label_text: 'table', custom_content: number, cases: cases)

        if table.top_titled?
          table.parent.add_class('os-top-titled-container')
          table.prepend(sibling:
            <<~HTML
              <div class="os-table-title">#{table.title}</div>
            HTML
          )
          table.title_row.trash
        end

        table.parent.add_class('os-column-header-container') if table.column_header?
      end
    end
  end
end
