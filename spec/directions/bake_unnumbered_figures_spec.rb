# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeUnnumberedFigures do

  let(:unnumbered_figure) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <figure id="someId" class="unnumbered">
            <span>
              <img src="img.jpg"/>
            </span>
          </figure>
        HTML
      )
    )
  end

  let(:unnumbered_figure_with_caption) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <figure id="someId" class="unnumbered">
            <figcaption>figure caption</figcaption>
            <span>
              <img src="img.jpg"/>
            </span>
          </figure>
        HTML
      )
    )
  end

  let(:unnumbered_splash_figure_with_caption) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <figure id="someId" class="unnumbered splash">
            <figcaption>figure caption</figcaption>
            <span>
              <img src="img.jpg"/>
            </span>
          </figure>
        HTML
      )
    )
  end

  context 'when figure is unnumbered without any other classes' do
    it 'does not change original figure' do
      described_class.v1(book: unnumbered_figure)
      expect(unnumbered_figure.pages.first).to match_normalized_html(
        <<~HTML
          <div data-type="page">
            <figure class="unnumbered" id="someId">
              <span>
                <img src="img.jpg" />
              </span>
            </figure>
          </div>
        HTML
      )
    end
  end

  context 'when figure is unnumbered and has caption' do
    it 'bakes' do
      described_class.v1(book: unnumbered_figure_with_caption)
      expect(unnumbered_figure_with_caption.search('.os-figure').first).to match_html_nodes(
        <<~HTML
          <div class="os-figure">
            <figure class="unnumbered has-caption" id="someId">
              <span >
                <img src="img.jpg" />
              </span>
            </figure>
            <div class="os-caption-container">
              <span class="os-caption">figure caption</span>
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when splash figure is unnumbered and has caption' do
    it 'bakes' do
      described_class.v1(book: unnumbered_splash_figure_with_caption)
      expect(unnumbered_splash_figure_with_caption.search('.os-figure').first).to match_html_nodes(
        <<~HTML
          <div class="os-figure has-splash">
            <figure class="unnumbered splash has-caption" id="someId">
              <span >
                <img src="img.jpg" />
              </span>
            </figure>
            <div class="os-caption-container">
              <span class="os-caption">figure caption</span>
            </div>
          </div>
        HTML
      )
    end
  end
end
