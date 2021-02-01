require 'spec_helper'

RSpec.describe Kitchen::Directions::BakePreface::V1 do
  let(:book_1) do
    book_containing(html:
      <<~HTML
        <div data-type="page" class="preface">
          <div data-type="document-title">Preface</div>
          <div data-type="metadata">
            <div data-type="document-title">Preface</div>
          </div>
        </div>
      HTML
    )
  end

  it 'selects div[data-type = "document-title"] in .preface, replaces the div with an h1, and nests a span with the text content in the span' do
    described_class.v1(book: book_1)

    expect(book_1.page.titles).to match_normalized_html(
      <<~HTML
        <div data-type="page" class="preface">
          <h1 data-type="document-title">
            <span data-type="" itemprop="" class="os-text">Preface</span>
          </h1>
          <div data-type="metadata">
            <h1 data-type="document-title">
              <span data-type="" itemprop="" class="os-text">Preface</span>
            </h1>
          </div>
        </div>
      HTML
    )
  end
end
