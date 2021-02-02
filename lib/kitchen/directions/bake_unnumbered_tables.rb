module Kitchen
  module Directions
    module BakeUnnumberedTables
      def self.v1(book:)
        book.tables('$.unnumbered').each do |table|
          table.wrap(%(<div class="os-table">))
          table.remove_attribute('summary')
          if table.unstyled?
            table.parent.add_class('os-unstyled-container')
          end
        end
      end
    end
  end
end
