# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakePreface::V1 do
  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="page" class="preface">
          <div data-type="document-title">Preface</div>
          <div data-type="metadata">
            <div data-type="document-title">Preface</div>
          </div>
        </div>
        <div data-type="page" class="preface">
          <div data-type="document-title">Preface</div>
          <div class="description" data-type="description" itemprop="description">description</div>
          <div data-type="metadata">
            <div data-type="document-title">Preface</div>
          </div>
          <div data-type="abstract" id="abcde">abstract</div>
        </div>
      HTML
    )
  end

  let(:book_containing_preface_with_figures) do
    book_containing(html:
      <<~HTML
        <div data-type="page" class="preface">
          <section>
            <figure id="auto_65d6f438-78c0-4b74-8701-ef973b62bdbf_people" class="unnumbered">
              <div data-type="title" id="auto_65d6f438-78c0-4b74-8701-ef973b62bdbf_1">People of the World</div>
              <figcaption>People of the World. The figure title for this piece of art is “People of the World” and the caption follows. Captions should be written in complete sentences.</figcaption>
                <span data-type="media" id="auto_65d6f438-78c0-4b74-8701-ef973b62bdbf_peopleoftheworld" data-alt="Alt text placeholder">
                  <img src="65d6f438-78c0-4b74-8701-ef973b62bdbf/Figure 00_PP_Art1.png" data-media-type="image/png" alt="Alt text placeholder" id="auto_65d6f438-78c0-4b74-8701-ef973b62bdbf_2"/>
                </span>
            </figure>
          </section>
        </div>
        <div data-type="page" class="preface">
          <div data-type="document-title">Preface</div>
          <div class="description" data-type="description" itemprop="description">description</div>
          <div data-type="metadata">
            <div data-type="document-title">Preface</div>
          </div>
          <div data-type="abstract" id="abcde">abstract</div>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(book: book1, title_element: 'h1')

    expected = <<~HTML
      <div class="preface" data-type="page">
        <h1 data-type="document-title">
          <span class="os-text" data-type="" itemprop="">Preface</span>
        </h1>
        <div data-type="metadata">
          <h1 data-type="document-title">
            <span class="os-text" data-type="" itemprop="">Preface</span>
          </h1>
        </div>
      </div>
    HTML

    expect(book1.search('div.preface')).to all(match_normalized_html(expected))
  end

  context 'when preface contains figures' do
    it 'bakes' do
      described_class.new.bake(book: book_containing_preface_with_figures, title_element: 'h1')
      expect(book_containing_preface_with_figures.pages.first).to match_normalized_html(
        <<~HTML
          <div class="preface" data-type="page">
            <section>
              <div class="os-figure">
                <figure class="unnumbered" id="auto_65d6f438-78c0-4b74-8701-ef973b62bdbf_people">
                  <div data-type="title" id="auto_65d6f438-78c0-4b74-8701-ef973b62bdbf_1">People of the World</div>
                  <span data-alt="Alt text placeholder" data-type="media" id="auto_65d6f438-78c0-4b74-8701-ef973b62bdbf_peopleoftheworld">
                    <img alt="Alt text placeholder" data-media-type="image/png" id="auto_65d6f438-78c0-4b74-8701-ef973b62bdbf_2" src="65d6f438-78c0-4b74-8701-ef973b62bdbf/Figure 00_PP_Art1.png" />
                  </span>
                </figure>
                <div class="os-caption-container">
                  <span class="os-caption">People of the World. The figure title for this piece of art is &#x201C;People of the World&#x201D; and the caption follows. Captions should be written in complete sentences.</span>
                </div>
              </div>
            </section>
          </div>
        HTML
      )
    end
  end
end
