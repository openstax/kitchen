# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeReferences::V2 do
  let(:book1) do
    book_containing(html:
    <<~HTML
      <div data-type="metadata" style="display: none;">
        <div class="authors" id="authors">Authors</div>
        <div class="publishers" id="publishers">Publishers</div>
        <div class="print-style" id="print-style">Print Style</div>
        <div class="permissions" id="permissions">Permissions</div>
        <div data-type="subject" id="subject">Subject</div>
      </div>
      <div data-type="chapter">
        <h1 data-type="document-title" id="chapTitle1">
          <span class="os-part-text">Chapter </span>
          <span class="os-number">1</span>
          <span class="os-divider"> </span>
          <span class="os-text" data-type="" itemprop="">Title Text Chapter 1</span>
        </h1>
        <div data-type="page">
          <h2 data-type='document-title'>Stuff and Things</h2>
          <section data-depth="1" id="1" class="reference">
            <h3 data-type="title">References</h3>
            <p>Prattchett, Terry: The Color of Magic</p>
          </section>
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
          <h2 data-type='document-title'>Somehing</h2>
          <section data-depth="1" id="2" class="reference">
            <h3 data-type="title">References</h3>
            <p>American Psychological Association</p>
          </section>
        </div>
      </div>
    HTML
    )
  end

  it 'works' do
    described_class.new.bake(book: book1)
    expect(book1.chapters.search('.os-chapter-area').to_s).to match_normalized_html(
      <<~HTML
        <div class="os-chapter-area">
          <h2 data-type="document-title">
            <span class="os-text" data-type="" itemprop="">Title Text Chapter 1</span>
          </h2>
          <section data-depth="1" id="1" class="reference">
            <p>Prattchett, Terry: The Color of Magic</p>
          </section>
        </div>
        <div class="os-chapter-area">
          <h2 data-type="document-title">
            <span class="os-text" data-type="" itemprop="">Title Text Chapter 2</span>
          </h2>
          <section data-depth="1" id="2" class="reference">
            <p>American Psychological Association</p>
          </section>
        </div>
      HTML
    )
  end
end
