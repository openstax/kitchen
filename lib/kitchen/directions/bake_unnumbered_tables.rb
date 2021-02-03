module Kitchen
  module Directions
    module BakeUnnumberedTables
      def self.v1(book:)
        book.tables('$.unnumbered').each do |table|
          table.wrap(%(<div class="os-table">))
          table.remove_attribute('summary')
          table.unstyled? ? table.parent.add_class('os-unstyled-container') : 0
          table.column_header? ? table.parent.add_class('os-column-header-container') : 0
        end
      end
    end
  end
end
