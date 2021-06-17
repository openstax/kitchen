# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeGenericEocSection::V1 do
  before do
    stub_locales({
      'eoc': {
        'top-level': 'Top Level Container',
        'some-eoc-section': 'Some Eoc Section'
      },
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

  let(:book_with_section_to_move) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <h2 data-type="document-title" id="first" itemprop="name">First Title</h2>
            <section id="sectionId1" class="some-eoc-section">
              <p>content</p>
            </section>
            <section id="sectionId2" class="some-eoc-section">
              <p>content</p>
            </section>
          </div>
          <div data-type="page">
            <section id="sectionId3" class="some-eoc-section">
              <p>content</p>
            </section>
          </div>
        </div>
      HTML
    )
  end

  context 'when append_to is not null' do
    it 'works' do
      described_class.new.bake(chapter: book_with_section_to_move.chapters.first, metadata_source: metadata_element, append_to: append_to, klass: 'some-eoc-section')
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
                <div class="authors" id="authors_copy_1">Authors</div>
                <div class="publishers" id="publishers_copy_1">Publishers</div>
                <div class="print-style" id="print-style_copy_1">Print Style</div>
                <div class="permissions" id="permissions_copy_1">Permissions</div>
                <div data-type="subject" id="subject_copy_1">Subject</div>
              </div>
              <section class="some-eoc-section" id="sectionId1">
                <p>content</p>
              </section>
              <section class="some-eoc-section" id="sectionId2">
                <p>content</p>
              </section>
              <section class="some-eoc-section" id="sectionId3">
                <p>content</p>
              </section>
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when append_to is null' do
    it 'works' do
      described_class.new.bake(chapter: book_with_section_to_move.chapters.first, metadata_source: metadata_element, klass: 'some-eoc-section')
      expect(book_with_section_to_move.chapters.search('.os-eoc').first).to match_normalized_html(
        <<~HTML
          <div class="os-eoc os-some-eoc-section-container" data-type="composite-page" data-uuid-key=".some-eoc-section">
            <h2 data-type="document-title">
              <span class="os-text">Some Eoc Section</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Some Eoc Section</h1>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <section class="some-eoc-section" id="sectionId1">
              <p>content</p>
            </section>
            <section class="some-eoc-section" id="sectionId2">
              <p>content</p>
            </section>
            <section class="some-eoc-section" id="sectionId3">
              <p>content</p>
            </section>
          </div>
        HTML
      )
    end
  end

  it 'sends content to strategies' do
    expect(Kitchen::Directions::EocContentTransform).to receive(:foo).at_least(:once)
    expect(Kitchen::Directions::EocContentTransform).to receive(:bar).at_least(:once)
    described_class.new.bake(chapter: book_with_section_to_move.chapters.first, metadata_source: metadata_element, klass: 'some-eoc-section',
                             content_transform: %i[foo bar])
  end
end
