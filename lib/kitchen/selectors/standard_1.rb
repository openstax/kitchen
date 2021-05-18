# frozen_string_literal: true

module Kitchen
  module Selectors
    # A specific set of selectors
    #
    class Standard1 < Base

      # Create a new instance
      #
      def initialize
        super
        self.title_in_page              = "./*[@data-type = 'document-title']"
        self.title_in_introduction_page = "./*[@data-type = 'document-title']"
        self.page_summary               = 'section.summary'
        self.reference                  = '.reference'
        self.chapter                    = "div[data-type='chapter']"
        self.page                       = "div[data-type='page']"
        self.note                       = "div[data-type='note']"
        self.term                       = "span[data-type='term']"
      end

    end
  end
end
