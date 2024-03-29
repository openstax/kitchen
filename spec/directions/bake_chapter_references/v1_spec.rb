# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterReferences::V1 do

  before do
    stub_locales({
      'eoc': {
        'references': 'References'
      }
    })
  end

  let(:chapter) do
    chapter_element(
      <<~HTML
        <div data-type="page" class="introduction">
          <h1 data-type='document-title'>Introduction to Sociology</h1>
          <section data-depth="1" id="1" class="reference">
            <h3 data-type="title">References</h3>
            <p>Elias, Norbert. 1978. What Is Sociology? New York: Columbia University Press.</p>
          </section>
        </div>
        <div data-type="page">
          <h1 data-type='document-title'>What Is Sociology?</h1>
          <section data-depth="1" id="2" class="reference">
            <h3 data-type="title">References</h3>
            <p>Abercrombie, Nicholas, Stephen Hill, and Bryan S. Turner. 2000. The Penguin Dictionary of Sociology. London: Penguin.</p>
          </section>
        </div>
        <div data-type="page">
        <h1 data-type='document-title'>The History of Sociology</h1>
          <section data-depth="1" id="3" class="reference">
            <h3 data-type="title">References</h3>
            <p>Kierns, N. (2010). Ashley’s Alliance, unpublished presentation. Ohio State University.</p>
          </section>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(chapter: chapter, metadata_source: metadata_element)
    expect(chapter).to match_normalized_html(
      <<~HTML
        <div data-type="chapter">
          <div data-type="page" class="introduction">
            <h1 data-type='document-title'>Introduction to Sociology</h1>
          </div>
          <div data-type="page">
          <h1 data-type="document-title">What Is Sociology?</h1>
          </div>
          <div data-type="page">
            <h1 data-type="document-title">The History of Sociology</h1>
          </div>
          <div class="os-eoc os-references-container" data-type="composite-page" data-uuid-key=".references">
            <h2 data-type="document-title">
              <span class="os-text">References</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">References</h1>
              <span data-type="revised" id="revised_copy_1">Revised</span>
              <span data-type="slug" id="slug_copy_1">Slug</span>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <section class="reference" data-depth="1" id="1">
              <a href="#">
                <h3 data-type="document-title" id="">
                  <span class="os-text" data-type="" itemprop="">Introduction to Sociology</span>
                </h3>
              </a>
              <p>Elias, Norbert. 1978. What Is Sociology? New York: Columbia University Press.</p>
            </section>
            <section class="reference" data-depth="1" id="2">
              <a href="#">
                <h3 data-type="document-title" id="">
                  <span class="os-number">1.1</span>
                  <span class="os-divider"> </span>
                  <span class="os-text" data-type="" itemprop="">What Is Sociology?</span>
                </h3>
              </a>
              <p>Abercrombie, Nicholas, Stephen Hill, and Bryan S. Turner. 2000. The Penguin Dictionary of Sociology. London: Penguin.</p>
            </section>
            <section class="reference" data-depth="1" id="3">
              <a href="#">
                <h3 data-type="document-title" id="">
                  <span class="os-number">1.2</span>
                  <span class="os-divider"> </span>
                  <span class="os-text" data-type="" itemprop="">The History of Sociology</span>
                </h3>
              </a>
              <p>Kierns, N. (2010). Ashley’s Alliance, unpublished presentation. Ohio State University.</p>
            </section>
          </div>
        </div>
    HTML
    )
  end
end
