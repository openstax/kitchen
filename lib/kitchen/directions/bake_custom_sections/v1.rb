# frozen_string_literal: true

module Kitchen::Directions::BakeCustomSections
  class V1
    def bake(chapter:)
      # $Config_Custom_Section: (
      #   (className: 'narrative-trailblazer', text: "Literacy Narrative Trailblazer", inject: 'title'),
      #   (className: 'living-words', text: "Living by Their Own Words", inject: 'subtitle'),
      #   (className: 'quick-launch', text: "Quick Launch: ", inject: 'title_prefix'),
      # );

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

      custom_sections_properties.each do |custom_section_name, property|
        # custom_section_name.each do |property|
            # puts klasa.class
            # if custom_section == "narrative_trailblazer"
              # section_properties.each do |property, value|
              # szukana_klasa = chapter.non_introduction_pages.search("#{property[:class]}")
              # puts szukana_klasa.class
            property_classes = property[:class]
            inject = property[:inject]
            # puts property_classes.class
            # property_class.each do
            chapter.search(".#{property_classes}").each do |custom_section|
              # puts custom_section
              # puts custom_section
              inject = property[:inject]
              # custom_section_name = custom_section.name
              # case custom_section_name
              # when 'div.[data-type="page"]'
              #   custom_section_title = custom_section.title
              # when custom_section.name == 'section'
              #   custom_section_title = custom_section.titles.first
              # end
              case inject
              when 'title'
                custom_section_title = custom_section.at('h2').first('.os-text')
                # custom_section_title = custom_section.titles.first
                custom_section_title_text = custom_section_title.text
                custom_section_title.name = 'h3'

                custom_section_title.raw.next_sibling.add_class('os-subtitle').name = h3
                custom_section_title.raw.next_sibling.replace_children(with:
                  "#{custom_section_title_text}"
                )
                # custom_section.title_text.replace_children(with: "#{title_text}}")
              when 'subtitle'
                # puts custom_section_title
                custom_section_title = custom_section.titles.first
                # puts custom_section_title
                custom_section_title.name = 'h4'
                custom_section_title.prepend(sibling:
                  <<~HTML
                    <h3 class="os-title">#{property[:text]}</span>
                  HTML
                )
              when 'title_prefix'
                custom_section_title = custom_section.titles.first
                title_text = custom_section_title.text
                custom_section_title.replace_children(with:
                  <<~HTML
                  #{property[:text]} #{title_text}</span>
                  HTML
                )
              end
            end
          # end
        end
      # end


    end
  end
end


