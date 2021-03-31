# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeTitledNote do
  let(:note) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="note" id="noteId" class="foo">
            <p>content</p>
          </div>
        HTML
      )
    ).notes.first
  end

  let(:titled_note) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="note" id="noteId" class="baz">
            <div data-type="title" id="titleId">note <em data-effect="italics">title</em></div>
            <p>content</p>
          </div>
        HTML
      )
    ).notes.first
  end

  before do
    stub_locales({
      'notes': {
        'foo': 'Bar',
        'baz': 'Baaa'
      }
    })
  end

  it 'bakes without subtitle' do
    described_class.v1(note: note)
    expect(note).to match_normalized_html(
      <<~HTML
        <div data-type="note" id="noteId" class="foo">
          <h3 class="os-title" data-type="title">
            <span class="os-title-label">Bar</span>
          </h3>
          <div class="os-note-body">
            <p>content</p>
          </div>
        </div>
      HTML
    )
  end

  it 'bakes with subtitle' do
    described_class.v1(note: titled_note)
    expect(titled_note).to match_normalized_html(
      <<~HTML
        <div data-type="note" id="noteId" class="baz">
          <h3 class="os-title" data-type="title">
            <span class="os-title-label">Baaa</span>
          </h3>
          <div class="os-note-body">
            <h4 class="os-subtitle" data-type="title" id="titleId">
              <span class="os-subtitle-label">note <em data-effect="italics">title</em></span>
            </h4>
            <p>content</p>
          </div>
        </div>
      HTML
    )
  end
end
