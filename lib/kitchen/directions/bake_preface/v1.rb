# frozen_string_literal: true

module Kitchen::Directions::BakePreface
  class V1
    def bake(book:, title_element:)
      book.pages('$.preface').each do |page|
        page.search('div[data-type="description"], div[data-type="abstract"]').each(&:trash)
        page.titles.each do |title|
          title.replace_children(with:
            <<~HTML
              <span data-type="" itemprop="" class="os-text">#{title.text}</span>
            HTML
          )
          title.name = title_element
        end
        unnumbered_figures = page.figures('$.unnumbered')
        next if unnumbered_figures.none?

        unnumbered_figures.each do |unnumbered_figure|
          Kitchen::Directions::BakeFigure.v1(figure: unnumbered_figure)
        end
      end
    end
  end
end
