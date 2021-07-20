# frozen_string_literal: true

module Kitchen::Directions::BakeHandbook
  class V1
    def bake(book:, title_element:)
      outline_html = ''
      outline_items_html = ''

      book.pages('$.handbook').each do |page|
        page.titles.each do |title|
          title.replace_children(with:
            <<~HTML
              <span data-type="" itemprop="" class="os-text">#{title.text}</span>
            HTML
          )
          title.name = title_element
        end
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
      end

      outline_items_html = book.pages('$.handbook').search('> section').map do |section|
        section_title = section.titles.first
        section_title_text = section_title.text
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
