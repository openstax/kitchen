require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeAppendix do
  let(:doc) do
    Kitchen::BookDocument.new(document: Nokogiri::XML(<<~HTML
      <html>
      <body>
        <div data-type="chapter">
          <div data-type="page">
            <div data-type="document-title">zzzzzzz</div>
            <section>
              <div data-type="title">hello</div>
              <div>world</div>
            </section>
          </div>
        </div>
      </body>
      </html>
    HTML
    ))
  end

  it 'works' do
    page = doc.book.chapters.first.pages.first
    described_class.v1(page: page, number: 3)
    expect(page).to match_normalized_html(
      <<~HTML
        <div data-type="page">
          <h1 data-type="document-title">
            <span class="os-part-text">Appendix </span>
            <span class="os-number">3</span>
            <span class="os-divider"> </span>
            <span class="os-text" data-type="" itemprop="">zzzzzzz</span>
          </h1>
          <section>
            <h1 data-type="title">hello</h1>
            <div>world</div>
          </section>
        </div>
      HTML
    )
  end
end
