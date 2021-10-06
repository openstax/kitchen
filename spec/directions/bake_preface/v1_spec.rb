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

  let(:book_containing_preface_with_unnumbered_figures) do
    book_containing(html:
      <<~HTML
        <div data-type="page" class="preface">
          <section>
            <figure class="unnumbered" id="someId-1">
              <div data-type="title" id="someId-1">First Figure Title</div>
              <span data-alt="Alt text placeholder" data-type="media" id="someId-1">
                <img alt="Alt text placeholder" data-media-type="image/png" id="someId-1" src="First Image.png" />
              </span>
            </figure>
            <figure id="someId-2" class="unnumbered">
              <div data-type="title" id="someId-2">Second Figure Title</div>
              <figcaption>Second Figure Title</figcaption>
                <span data-type="media" id="someId-2" data-alt="Alt text placeholder">
                  <img src="Second Image.png" data-media-type="image/png" alt="Alt text placeholder" id="someId-2"/>
                </span>
            </figure>
            <figure id="someId-3" class="unnumbered">
              <figcaption>Third Figure Caption</figcaption>
                <span data-type="media" id="someId-3" data-alt="Alt text placeholder">
                  <img src="Third Image.png" data-media-type="image/png" alt="Alt text placeholder" id="someId-3"/>
                </span>
            </figure>
            <figure id="someId-4" class="unnumbered">
                <span data-type="media" id="someId-4" data-alt="Alt text placeholder">
                  <img src="Fourth Image.png" data-media-type="image/png" alt="Alt text placeholder" id="someId-4"/>
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
      described_class.new.bake(book: book_containing_preface_with_unnumbered_figures, title_element: 'h1')
      expect(book_containing_preface_with_unnumbered_figures.pages.first).to match_normalized_html(
        <<~HTML
          <div class="preface" data-type="page">
            <section>
              <div class="os-figure">
                <figure class="unnumbered" id="someId-1">
                  <span data-alt="Alt text placeholder" data-type="media" id="someId-1">
                  <img alt="Alt text placeholder" data-media-type="image/png" id="someId-1" src="First Image.png" />
                  </span>
                </figure>
                <div class="os-caption-container">
                  <span class="os-title" data-type="title" id="someId-1">First Figure Title</span>
                </div>
              </div>
              <div class="os-figure">
                  <figure class="unnumbered" id="someId-2">
                    <span data-alt="Alt text placeholder" data-type="media" id="someId-2">
                      <img alt="Alt text placeholder" data-media-type="image/png" id="someId-2" src="Second Image.png" />
                   </span>
                  </figure>
                  <div class="os-caption-container">
                    <span class="os-title" data-type="title" id="someId-2">Second Figure Title</span>
                    <span class="os-caption">Second Figure Title</span>
                  </div>
                </div>
                <div class="os-figure">
                  <figure class="unnumbered" id="someId-3">
                    <span data-alt="Alt text placeholder" data-type="media" id="someId-3">
                      <img alt="Alt text placeholder" data-media-type="image/png" id="someId-3" src="Third Image.png" />
                    </span>
                  </figure>
                  <div class="os-caption-container">
                    <span class="os-caption">Third Figure Caption</span>
                  </div>
                </div>
                <figure class="unnumbered" id="someId-4">
                  <span data-alt="Alt text placeholder" data-type="media" id="someId-4">
                    <img alt="Alt text placeholder" data-media-type="image/png" id="someId-4" src="Fourth Image.png" />
                  </span>
                </figure>
            </section>
          </div>
        HTML
      )
    end
  end
end
