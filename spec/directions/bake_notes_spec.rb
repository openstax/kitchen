# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNotes do

  let(:book_with_titled_note) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="note" id="noteId">
            <div data-type="title" id="titleId"><em>Answer:</em></div>Foo<p id="pId">Blah</p>
          </div>
        HTML
      )
    )
  end

  let(:book_with_untitled_note) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="note" id="noteId" class="chemistry link-to-learning">
            <p id="pId">Blah</p>
          </div>
        HTML
      )
    )
  end

  let(:book_with_titled_note_and_needs_autogenerated_title) do
    book_containing(short_name: :chemistry, html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="note" id="noteId" class="everyday-life">
            <div data-type="title" id="titleId"><em>Answer:</em></div>
            <p id="pId">Blah</p>
          </div>
        HTML
      )
    )
  end

  before do
    stub_locales({
      'notes': {
        'link-to-learning': 'Link to Learning',
        'chemistry': {
          'link-to-learning': 'Chemistry',
          'everyday-life': 'Chemistry in Everyday Life'
        }
      }
    })
  end

  describe 'v1' do
    let(:book) { book_with_titled_note }

    context 'with title' do
      it 'works' do
        described_class.v1(book: book)

        expect(book.search("[data-type='note']").first).to match_normalized_html_with_stripping(
          <<~HTML
            <div data-type="note" id="noteId">
              <h3 class="os-title" data-type="title">
                <span data-type="" id="titleId" class="os-title-label"><em>Answer:</em></span>
              </h3>
              <div class="os-note-body">
                Foo<p id="pId">Blah</p>
              </div>
            </div>
          HTML
        )
      end
    end

    context 'without title' do
      let(:book) { book_with_untitled_note }

      it 'works' do
        described_class.v1(book: book)

        expect(book.search("[data-type='note']").first).to match_html_nodes(
          <<~HTML
            <div data-type="note" id="noteId" class="chemistry link-to-learning">
              <h3 class="os-title" data-type="title">
                <span class="os-title-label">Link to Learning</span>
              </h3>
              <div class="os-note-body">
                <p id="pId">Blah</p>
              </div>
            </div>
          HTML
        )
      end
    end

    context 'with title and needing autogenerated title' do
      let(:book) { book_with_titled_note_and_needs_autogenerated_title }

      it 'works' do
        described_class.v1(book: book)

        expect(book.search("[data-type='note']").first).to match_html_nodes(
          <<~HTML
            <div data-type="note" id="noteId" class="everyday-life">
              <h3 class="os-title" data-type="title">
                <span class="os-title-label">Chemistry in Everyday Life</span>
              </h3>
              <div class="os-note-body">
                <h4 data-type="title" id="titleId" class="os-subtitle">
                  <span class="os-subtitle-label"><em>Answer:</em></span>
                </h4>
                <p id="pId">Blah</p>
              </div>
            </div>
          HTML
        )

      end
    end

  end
end
