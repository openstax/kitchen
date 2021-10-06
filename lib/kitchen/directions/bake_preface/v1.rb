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
        preface_figures_to_bake = page.figures(only: :figure_to_bake_without_count?)
        next if preface_figures_to_bake.none?

        preface_figures_to_bake.each do |preface_figure_to_bake|
          Kitchen::Directions::BakeFigure.v1(figure: preface_figure_to_bake)
        end
      end
    end
  end
end
