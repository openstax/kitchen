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

  let(:book_with_checkpoints_and_theorems) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="note" id="note_id" class="checkpoint">
            <div data-type="exercise" id="exercise_id">
              <div data-type="problem" id="problem_id">
                <p>problem content</p>
              </div>
              <div data-type="solution" id="solution_id">
                <p>solution content</p>
              </div>
              <div data-type="commentary" id="an_id" data-element-type="hint">
                <div data-type="title" id="hint_title_id">Hint</div>
                <p id="id"></p>
              </div>
            </div>
          </div>

          <div data-type="note" id="2note_id" class="theorem">
            <div data-type="title" id="title2">Two Important Limits</div>
            <p id="another_id">Content</p>
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

        expect(book.notes.first).to match_normalized_html_with_stripping(
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

        expect(book.notes.first).to match_html_nodes(
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

        expect(book.notes.first).to match_html_nodes(
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

    context 'with different classnames' do
      let(:book) { book_with_checkpoints_and_theorems }

      before do
        described_class.v1(book: book)
      end

      it 'checkpoints' do
        note = book.first('.checkpoint')
        described_class.bake_checkpoint_note(note: note, number: 1.1)
        expect(note).to match_normalized_html(
          <<~HTML
            <div data-type="note" id="note_id" class="checkpoint">
              <h3 class="os-title">
                <span class="os-title-label">Checkpoint </span>
                <span class="os-number">1.1</span>
                <span class="os-divider"> </span>
              </h3>
              <div class="os-note-body">
                <div data-type="exercise" id="exercise_id" class="os-hasSolution unnumbered">
                  <div data-type="problem" id="problem_id">
                    <p>problem content</p>
                  </div>
                  <div data-type="solution" id="solution_id"><span class="os-divider"> </span>
                    <a class="os-number" href="#exercise_id">1.1</a>
                    <div class="os-solution-container ">
                      <p>solution content</p>
                    </div>
                  </div>
                  <div data-type="commentary" id="an_id" data-element-type="hint">
                    <div data-type="title" id="hint_title_id">Hint</div>
                    <p id="id"/>
                  </div>
                </div>
              </div>
            </div>
          HTML
        )
      end
    end
  end
end
