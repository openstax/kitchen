require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterGlossary do

  # TODO: test that...
  # 1) definitions with the same term sort next by the definition

  let(:doc) do
    Kitchen::BookDocument.new(document: Nokogiri::XML(
      <<~HTML
        <html>
        <body>
          <div data-type="chapter">
            <div data-type='glossary'>
              <div>
                <dl>
                  <dt>ZzZ</dt>
                  <dd>Test 1</dd>
                </dl>
                <dl>
                  <dt>ZzZ</dt>
                  <dd>Achoo</dd>
                </dl>
                <dl>
                  <dt>ABD</dt>
                  <dd>Test 2</dd>
                </dl>
              </div>
            </div>
          </div>
        </body>
        </html>
      HTML
    ))
  end

  let(:metadata) do
    new_element(
      <<~HTML
        <div data-type="metadata" style="display: none;">
          <div class="authors" id="authors">Authors</div>
          <div class="publishers" id="publishers">Publishers</div>
          <div class="print-style" id="print-style">Print Style</div>
          <div class="permissions" id="permissions">Permissions</div>
          <div data-type="subject" id="subject">Subject</div>
        </div>
      HTML
    )
  end

  it 'works' do
    expect(
      described_class.v1(chapter: doc.book.chapters.first, metadata_source: metadata)
    ).to match_normalized_html(
      <<~HTML
        <div data-type="chapter">
          <div class="os-eoc os-glossary-container" data-type="composite-page" data-uuid-key="glossary">
            <h2 data-type="document-title">
              <span class="os-text">Key Terms</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Key Terms</h1>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <dl>
              <dt>ABD</dt>
              <dd>Test 2</dd>
            </dl>
            <dl>
              <dt>ZzZ</dt>
              <dd>Achoo</dd>
            </dl>
            <dl>
              <dt>ZzZ</dt>
              <dd>Test 1</dd>
            </dl>
          </div>
        </div>
      HTML
    )
  end
end
