require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterSummary do

  let(:chapter) do
    chapter_element(
      <<~HTML
        <div data-type='page' id ="01">
          <h1 data-type="document-title" itemprop="name">First Title</h1>
          <section class="summary" data-element-type="section-summary">
              <h3 data-type='title'>Summary</h3>
              <p>Many paragraphs provide a good summary.</p>
          </section>
        </div>
        <div data-type='page' id="02">
          <h1 data-type="document-title" itemprop="name">Second Title</h1>
          <section class="summary" data-element-type="section-summary">
              <h3 data-type='title'>Summary</h3>
              <p>Ooh, it's another bit of text.</p>
          </section>
        </div>
      HTML
    )
  end

  #TODO: check that it:
  #Replaces title with h3 title (children: os-number, os-divider, os-text)
  #

  context 'when v1 is called on a chapter' do
    it 'works' do
      described_class.v1(chapter: chapter, metadata_source: metadata_element)
      expect(
        chapter
      ).to match_normalized_html(
        <<~HTML
          <div data-type="chapter">
            <div data-type="page" id="01">
              <h1 data-type="document-title" itemprop="name">First Title</h1>
            </div>
            <div data-type="page" id="02">
              <h1 data-type="document-title" itemprop="name">Second Title</h1>
            </div>
            <div class="os-eoc os-summary-container" data-type="composite-page" data-uuid-key=".summary">
              <h2 data-type="document-title">
                <span class="os-text">Summary</span>
              </h2>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">Summary</h1>
                <div class="authors" id="authors_copy_1">Authors</div>
                <div class="publishers" id="publishers_copy_1">Publishers</div>
                <div class="print-style" id="print-style_copy_1">Print Style</div>
                <div class="permissions" id="permissions_copy_1">Permissions</div>
                <div data-type="subject" id="subject_copy_1">Subject</div>
              </div>
              <section class="summary" data-element-type="section-summary">
                <a href="#">
                  <h3 data-type="document-title" itemprop="name">
                    <span class="os-number">1.1</span>
                    <span class="os-divider"> </span>
                    <span class="os-text" data-type="" itemprop="">First Title</span>
                  </h3>
                </a>
                <p>Many paragraphs provide a good summary.</p>
              </section>
              <section class="summary" data-element-type="section-summary">
                <a href="#">
                  <h3 data-type="document-title" itemprop="name">
                    <span class="os-number">1.2</span>
                    <span class="os-divider"> </span>
                    <span class="os-text" data-type="" itemprop="">Second Title</span>
                  </h3>
                </a>
                <p>Ooh, it's another bit of text.</p>
              </section>
            </div>
          </div>
        HTML
      )
    end
  end
end
