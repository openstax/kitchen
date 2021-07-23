# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeReferences::V3 do

  let(:book1) do
    book_containing(html:
    <<~HTML
      <div data-type="chapter">
        <h1 data-type="document-title" id="chapTitle1">
          <span class="os-part-text">Chapter </span>
          <span class="os-number">1</span>
          <span class="os-divider"> </span>
          <span class="os-text" data-type="" itemprop="">Title Text Chapter 1</span>
        </h1>
        <div data-type="page">
          #{metadata_element}
          <div data-type="document-title" id="someId1">1.1 Page</div>
          <p>
            <a href="#auto_12345" data-type="cite">
              <div data-type="note" class="reference" display="inline" id="auto_12345">
                <h3 data-type="title">Reference 1</h3>
              </div>
            </a>
            <a href="#auto_54321" data-type="cite">
              <div data-type="note" class="reference" display="inline" id="auto_54321">
                <h3 data-type="title">Reference 2</h3>
              </div>
            </a>
          </p>
        </div>
      </div>
      <div data-type="chapter">
        <h1 data-type="document-title" id="chapTitle2">
          <span class="os-part-text">Chapter </span>
          <span class="os-number">2</span>
          <span class="os-divider"> </span>
          <span class="os-text" data-type="" itemprop="">Title Text Chapter 2</span>
        </h1>
        <div data-type="page">
          #{metadata_element}
          <div data-type="document-title" id="someId2">2.1 Page</div>
          <p>
            <a href="#auto_6789" data-type="cite">
              <div data-type="note" class="reference" display="inline" id="auto_6789">
                <h3 data-type="title">Reference 3</h3>
              </div>
            </a>
          </p>
        </div>
      </div>
    HTML
    )
  end

  it 'works' do
    described_class.new.bake(book: book1, metadata_source: metadata_element)
    expect(book1.body.chapters.references).to match_normalized_html(
      <<~HTML
        <div data-type="note" class="reference" display="inline" id="auto_12345">
          <h2 data-type="document-title" id="someId1_copy_1">
            <span class="os-number">1.1 Page</span>
            <span class="os-divider"> </span>
            <span class="os-text" data-type="" itemprop="">1.1 Page </span>
          </h2>
        </div>
        <div data-type="note" class="reference" display="inline" id="auto_54321">
          <h2 data-type="document-title" id="someId1_copy_2">
            <span class="os-number">1.1 Page</span>
            <span class="os-divider"> </span>
            <span class="os-text" data-type="" itemprop="">1.1 Page </span>
          </h2>
        </div>
        <div data-type="note" class="reference" display="inline" id="auto_6789">
          <h2 data-type="document-title" id="someId2_copy_1">
            <span class="os-number">2.1 Page</span>
            <span class="os-divider"> </span>
            <span class="os-text" data-type="" itemprop="">2.1 Page </span>
          </h2>
        </div>
      HTML
    )
  end
end
