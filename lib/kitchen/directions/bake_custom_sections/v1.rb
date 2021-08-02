# frozen_string_literal: true

module Kitchen::Directions::BakeCustomSections
  class V1
    def bake(chapter:)
      custom_sections_properties = {
        narrative_trailblazer: {
          class: 'narrative-trailblazer',
          text: 'Literacy Narrative Trailblazer',
          inject: 'title'
        },
        living_words: {
          class: 'living-words',
          text: 'Living by Their Own Words',
          inject: 'subtitle'
        },
        quick_launch: {
          class: 'quick-launch',
          text: 'Quick Launch:',
          inject: 'title_prefix'
        }
      }

      custom_sections_properties.each do |_custom_section_name, property|
        property_classes = property[:class]
        inject = property[:inject]

        chapter.search(".#{property_classes}").each do |custom_section|

          case inject
          when 'title'
            custom_section_title = custom_section.at('h2')
            custom_section_title_os_text = custom_section.at('h2').first('.os-text')
            custom_section_title_sibling = custom_section_title.raw.next
            custom_section_title_sibling.name = 'h3'
            custom_section_title_sibling.add_class('os-subtitle')
            custom_section_title_sibling.children = custom_section_title_os_text.text
            custom_section_title_os_text.replace_children(with:
              <<~HTML
                #{property[:text]}
              HTML
            )
          when 'subtitle'
            custom_section_title = custom_section.titles.first
            custom_section_title.name = 'h4'
            custom_section_title.prepend(sibling:
              <<~HTML
                <h3 class="os-title">#{property[:text]}</span>
              HTML
            )
          when 'title_prefix'
            custom_section_title = custom_section.titles.first
            custom_section_title.replace_children(with:
              <<~HTML
                #{property[:text]} #{custom_section_title.text}</span>
              HTML
            )
          end
        end
      end
    end
  end
end
