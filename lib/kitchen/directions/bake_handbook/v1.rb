# frozen_string_literal: true

module Kitchen::Directions::BakeHandbook
  class V1
    def bake(book:, title_element:)
      book.pages('$.handbook').each do |page|
        page.titles.each do |title|
          title.replace_children(with:
            <<~HTML
              <span data-type="" itemprop="" class="os-text">#{title.text}</span>
            HTML
          )
          title.name = title_element
        end

        bake_first_section_title(page: page)

        # Create Outline Title
        outline_html = <<~HTML
          <div class="os-handbook-outline">
            <h3 class="os-title">#{I18n.t(:handbook_outline_title)}</h3>
          </div>
        HTML

        page.title.append(sibling:
          <<~HTML
            #{outline_html}
          HTML
        )
        fix_nested_section_headers(page: page)
      end
      bake_handbook_objectives(book: book)
    end

    # Bake Handbook First Section Title
    def bake_first_section_title(page:)
      page.search('> section').each do |section|
        first_section_title = section.titles.first
        first_section_title_text = first_section_title.text
        first_section_title.replace_children(with:
          <<~HTML
            <span class="os-part-text">H</span>
            <span class="os-number">#{section.count_in(:page)}</span>
            <span class="os-divider">. </span>
            <span class="os-text">#{first_section_title_text}</span>
          HTML
        )
        first_section_title.name = 'h2'
      end
    end

    # Change section headers
    def fix_nested_section_headers(page:)
      page.search('> section > section').each do |section|
        second_section_title = section.titles.first
        second_section_title.name = 'h3'
      end
      page.search('> section > section > section').each do |section|
        third_section_title = section.titles.first
        third_section_title.name = 'h4'
      end
      page.search('> section > section > section > section').each do |section|
        fourth_section_title = section.titles.first
        fourth_section_title.name = 'h5'
      end
    end

    # Bake Handbook Objectives
    def bake_handbook_objectives(book:)
      outline_items_html = book.pages('$.handbook').search('> section').map do |section|
        section_title = section.titles.first
        section_title_children = section_title.children
        <<~HTML
          <div class="os-handbook-objective">
            <a class="os-handbook-objective" href="##{section_title[:id]}">
              #{section_title_children}
            </a>
          </div>
        HTML
      end.join('')
      book.pages('$.handbook').search('.os-handbook-outline').first.append(child:
        <<~HTML
          #{outline_items_html}
        HTML
      )
    end
  end
end
