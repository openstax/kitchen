# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for link placeholders
    #
    module BakeLinkPlaceholders
      def self.v1(book:, cases: false, label_wrappers: false)
        book.search('a').each do |anchor|
          next unless anchor.text == '[link]'

          label_case = anchor['cmlnle:case']
          id = anchor[:href][1..-1]

          if cases
            pantry_name = if anchor.key?('case')
                            "#{label_case}_link_text"
                          else
                            'nominative_link_text'
                          end

            replacement = book.pantry(name: pantry_name).get(id)
          else
            replacement = book.pantry(name: :link_text).get(id)
          end

          if replacement.present?
            anchor.replace_children(with: replacement)
            if label_wrappers && anchor.has_class?('lo-reference')
              anchor.wrap_children('span', class: 'label-counter')
              anchor.prepend(child:
                <<~HTML
                  <span class="label-text">#{I18n.t(:lo_label_text)}</span>
                HTML
              )
            end
          else
            # TODO: log a warning!
            puts "warning! could not find a replacement for '[link]' on an element with ID '#{id}'"
          end
        end
      end
    end
  end
end
