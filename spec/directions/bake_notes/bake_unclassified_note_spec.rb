# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeUnclassifiedNote do
  let(:titled_note) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="note" id="noteId">
            <div data-type="title" id="titleId">note <em data-effect="italics">title</em></div>
            <p>content</p>
          </div>
        HTML
      )
    ).notes.first
  end

  let(:untitled_note) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="note" id="noteId">
            <p>content</p>
          </div>
        HTML
      )
    ).notes.first
  end

  it 'bakes with a title' do
    described_class.v1(note: titled_note)
    expect(titled_note).to match_normalized_html(
      <<~HTML
        <div class="unclassified" data-type="note" id="noteId">
          <h3 class="os-title" data-type="title">
            <span class="os-title-label" data-type="" id="titleId">note <em data-effect="italics">title</em></span>
          </h3>
          <div class="os-note-body">
            <p>content</p>
          </div>
        </div>
      HTML
    )
  end

  it 'bakes without a title' do
    described_class.v1(note: untitled_note)
    expect(untitled_note).to match_normalized_html(
      <<~HTML
        <div class="unclassified" data-type="note" id="noteId">
          <div class="os-note-body">
            <p>content</p>
          </div>
        </div>
      HTML
    )
  end

end
