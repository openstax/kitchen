# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::CompositePageContainer do
  before do
    stub_locales({
      'eoc': {
        'top-level': 'Top Level Container',
        'some-eoc-section': 'Some Eoc Section'
      },
      'eob': {
        'eob-section': 'EOB SECTION'
      }
    })
  end

  let(:append_to) do
    new_element(
      <<~HTML
        <div class="os-eoc os-top-level-container" data-type="composite-chapter" data-uuid-key=".top-level">
          <h2 data-type="document-title" id="composite-chapter-1">
            <span class="os-text">#{I18n.t(:'eoc.top-level')}</span>
          </h2>
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">#{I18n.t(:'eoc.top-level')}</h1>
            <div>metadata</div>
          </div>
        </div>
      HTML
    )
  end

  let(:some_content) do
    book_containing(html:
      <<~HTML
        <div class="content">
          <p>here is some content</p>
          <div>do <span>nested</span> elements do okay?</div>
        </div>
      HTML
    ).first('$.content')
  end

  let(:book) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="example" class="class1" id="div1">
            <p>This is a paragraph.</p>
          </div>
        HTML
      ))
  end

  it 'works' do
    described_class.v1(container_key: 'some-eoc-section', uuid_key: '.some-eoc-section', metadata_source: metadata_element, content: some_content, append_to: append_to)
    expect(append_to).to match_normalized_html(
      <<~HTML
        <div class="os-eoc os-top-level-container" data-type="composite-chapter" data-uuid-key=".top-level">
          <h2 data-type="document-title" id="composite-chapter-1">
            <span class="os-text">#{I18n.t(:'eoc.top-level')}</span>
          </h2>
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">#{I18n.t(:'eoc.top-level')}</h1>
            <div>metadata</div>
          </div>
          <div class="os-eoc os-some-eoc-section-container" data-type="composite-page" data-uuid-key=".some-eoc-section">
            <h3 data-type="title">
              <span class="os-text">Some Eoc Section</span>
            </h3>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Some Eoc Section</h1>
              <span data-type="revised" id="revised_copy_1">Revised</span>
              <span data-type="slug" id="slug_copy_1">Slug</span>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <div class="content">
              <p>here is some content</p>
              <div>do <span>nested</span> elements do okay?</div>
            </div>
          </div>
        </div>
      HTML
    )
  end

  it 'works for EOB sections' do
    described_class.v1(container_key: 'eob-section', uuid_key: '.eob-section', metadata_source: metadata_element, content: some_content, append_to: book.body)
    expect(book.body).to match_normalized_html(
      <<~HTML
        <body>
          <div data-type="chapter">
            <div data-type="page">
              <div data-type="example" class="class1" id="div1">
                <p>This is a paragraph.</p>
              </div>
            </div>
          </div>
          <div class="os-eob os-eob-section-container" data-type="composite-page" data-uuid-key=".eob-section">
            <h1 data-type="document-title">
              <span class="os-text">EOB SECTION</span>
            </h1>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">EOB SECTION</h1>
              <span data-type="revised" id="revised_copy_1">Revised</span><span data-type="slug" id="slug_copy_1">Slug</span>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <div class="content">
              <p>here is some content</p>
              <div>do <span>nested</span> elements do okay?</div>
            </div>
          </div>
        </body>
      HTML
    )
  end
end
