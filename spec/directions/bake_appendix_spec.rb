require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeAppendix do
  let(:page) do
    page_element(
      <<~HTML
        <div data-type="document-title">zzzzzzz</div>
              <section>
                <div data-type="title">hello</div>
                <section>
                  <div data-type="title">world</div>
                </section>
              </section>
        </div>
      HTML
    )
  end

  it 'works' do
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
            <section>
              <h2 data-type="title">world</h2>
            </section>
          </section>
        </div>
      HTML
    )
  end
end
