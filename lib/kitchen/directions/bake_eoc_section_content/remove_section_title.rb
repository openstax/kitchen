# frozen_string_literal: true

module Kitchen
  module Directions
    module RemoveSectionTitle
      def self.v1(section:)
        section.first('h3').trash
      end
    end
  end
end
