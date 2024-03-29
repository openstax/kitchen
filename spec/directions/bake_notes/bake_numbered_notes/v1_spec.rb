# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedNotes do
  let(:book_with_notes) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter"><div data-type="page" id="page_1">
          <div data-type="note" id="123" class="foo">
            <p>content 1.1</p>
          </div>
          <div data-type="note" id="111" class="hello">
            <p>content 1.1</p>
          </div>
          <div data-type="note" id="222" class="hello">
            <p>content 1.2</p>
          </div>
        </div></div>
        <div data-type="chapter"><div data-type="page" id="page_2">
          <div data-type="note" id="456" class="foo">
            <p>content 2.1</p>
          </div>
          <div data-type="note" id="789" class="foo">
            <p>content 2.2</p>
            <div data-type="exercise">
              <div data-type="problem">what is your quest?</div>
            </div>
          </div>
          <div data-type="note" id="333" class="hello">
            <p>content 2.1</p>
            <div data-type="exercise" id="abcde">
              <div data-type="problem" id="unchanged">what is your favorite color?</div>
              <div data-type="solution" id="xyz">
                <p>chartreuse</p>
              </div>
            </div>
          </div>
          <div data-type="note" id="000" class=":/">
            <p>don't bake me</p>
          </div>
          <div data-type="note" id="note_id15" class="theorem" use-subtitle="true">
            <div data-type="title" id="title_id15">Two Important Limits</div>
            <p> some content </p>
          </div>
          <div data-type="note" id="4" class="foo">
            <p>A title 4</p>
            <div data-type="exercise" id="123">
              <div data-type="problem" id="456">Problem content</div>
              <div data-type="solution" id="xyz">
                <p>solution content</p>
              </div>
              <div data-type="commentary" id="xyza">
                <p>remove me</p>
              </div>
            </div>
            <div data-type="exercise" id="2_123">
              <div data-type="problem" id="2_456">a <strong>second</strong> exercise</div>
              <div data-type="solution" id="2_xyz">
                <p>second solution content</p>
              </div>
            </div>
          </div>
          <div data-type="note" id="4" class="foo">
            <p>A title 4</p>
            <div data-type="injected-exercise">
              <div data-type="exercise-question" data-id="1">
                <div data-type="question-stem">a question stem</div>
                <div data-type="question-solution">
                  some solution
                </div>
              </div>
            </div>
          </div>
        </div></div>
      HTML
    )
  end

  before do
    stub_locales({
      'notes': {
        'foo': 'Bar',
        'hello': 'Hello World',
        'theorem': 'Theorem'
      }
    })
  end

  it 'bakes' do
    described_class.v1(book: book_with_notes, classes: %w[foo hello theorem])
    expect(book_with_notes.body).to match_normalized_html(
      <<~HTML
        <body>
          <div data-type="chapter"><div data-type="page" id="page_1">
            <div class="foo" data-type="note" id="123">
              <h3 class="os-title">
                <span class="os-title-label">Bar</span>
                <span class="os-number">1.1</span>
                <span class="os-divider"> </span>
              </h3>
              <div class="os-note-body">
                <p>content 1.1</p>
              </div>
            </div>
            <div class="hello" data-type="note" id="111">
              <h3 class="os-title">
                <span class="os-title-label">Hello World</span>
                <span class="os-number">1.1</span>
                <span class="os-divider"> </span>
              </h3>
              <div class="os-note-body">
                <p>content 1.1</p>
              </div>
            </div>
            <div class="hello" data-type="note" id="222">
              <h3 class="os-title">
                <span class="os-title-label">Hello World</span>
                <span class="os-number">1.2</span>
                <span class="os-divider"> </span>
              </h3>
              <div class="os-note-body">
                <p>content 1.2</p>
              </div>
            </div>
          </div></div>
          <div data-type="chapter"><div data-type="page" id="page_2">
            <div class="foo" data-type="note" id="456">
              <h3 class="os-title">
                <span class="os-title-label">Bar</span>
                <span class="os-number">2.1</span>
                <span class="os-divider"> </span>
              </h3>
              <div class="os-note-body">
                <p>content 2.1</p>
              </div>
            </div>
            <div class="foo" data-type="note" id="789">
              <h3 class="os-title">
                <span class="os-title-label">Bar</span>
                <span class="os-number">2.2</span>
                <span class="os-divider"> </span>
              </h3>
              <div class="os-note-body">
                <p>content 2.2</p>
                <div class="unnumbered" data-type="exercise">
                  <div data-type="problem">
                    <div class="os-problem-container">what is your quest?</div>
                  </div>
                </div>
              </div>
            </div>
            <div class="hello" data-type="note" id="333">
              <h3 class="os-title">
                <span class="os-title-label">Hello World</span>
                <span class="os-number">2.1</span>
                <span class="os-divider"> </span>
              </h3>
              <div class="os-note-body">
                <p>content 2.1</p>
                <div class="unnumbered os-hasSolution" data-type="exercise" id="abcde">
                  <div data-type="problem" id="unchanged">
                    <div class="os-problem-container">what is your favorite color?</div>
                  </div>
                  <div data-type="solution" id="abcde-solution">
                    <a class="os-number" href="#abcde">2.1</a>
                    <span class="os-divider"> </span>
                    <div class="os-solution-container">
                      <p>chartreuse</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div data-type="note" id="000" class=":/">
              <p>don't bake me</p>
            </div>
            <div class="theorem" data-type="note" id="note_id15" use-subtitle="true">
              <h3 class="os-title">
                <span class="os-title-label">Theorem</span>
                <span class="os-number">2.1</span>
                <span class="os-divider"> </span>
              </h3>
              <div class="os-note-body">
                <h4 class="os-subtitle" data-type="title" id="title_id15">
                  <span class="os-subtitle-label">Two Important Limits</span>
                </h4>
                <p> some content </p>
              </div>
            </div>
            <div class="foo" data-type="note" id="4">
              <h3 class="os-title">
                <span class="os-title-label">Bar</span>
                <span class="os-number">2.3</span>
                <span class="os-divider"> </span>
              </h3>
              <div class="os-note-body">
                <p>A title 4</p>
                <div class="unnumbered os-hasSolution" data-type="exercise" id="123">
                  <div data-type="problem" id="456">
                    <div class="os-problem-container">Problem content</div>
                  </div>
                  <div data-type="solution" id="123-solution">
                    <a class="os-number" href="#123">2.3</a>
                    <span class="os-divider"> </span>
                    <div class="os-solution-container">
                      <p>solution content</p>
                    </div>
                  </div>
                </div>
                <div class="unnumbered os-hasSolution" data-type="exercise" id="2_123">
                  <div data-type="problem" id="2_456">
                    <div class="os-problem-container">a <strong>second</strong> exercise</div>
                  </div>
                  <div data-type="solution" id="2_123-solution">
                    <a class="os-number" href="#2_123">2.3</a>
                    <span class="os-divider"> </span>
                    <div class="os-solution-container">
                      <p>second solution content</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="foo" data-type="note" id="4">
              <h3 class="os-title">
                <span class="os-title-label">Bar</span>
                <span class="os-number">2.4</span>
                <span class="os-divider"> </span>
              </h3>
              <div class="os-note-body">
                <p>A title 4</p>
                <div data-type="injected-exercise">
                  <div class="unnumbered os-hasSolution" data-type="exercise-question" data-id="1" id="auto_2_1">
                    <div class="os-problem-container">
                      <div data-type="question-stem">a question stem</div>
                    </div>
                    <div data-type="question-solution" id="auto_2_1-solution">
                      <a class="os-number" href="#auto_2_1">2.4</a>
                      <span class="os-divider">. </span>
                      <div class="os-solution-container">
                  some solution
                </div>
                    </div>
                  </div>
                </div>
            </div>
            </div>
          </div></div>
        </body>
      HTML
    )
  end

  context 'when book does not use grammatical cases' do
    it 'stores link text' do
      pantry = book_with_notes.pantry(name: :link_text)
      expect(pantry).to receive(:store).with('Two Important Limits', { label: 'note_id15' })
      described_class.v1(book: book_with_notes, classes: %w[foo hello theorem])
    end
  end

  context 'when book uses grammatical cases' do
    it 'stores link text' do
      with_locale(:pl) do
        stub_locales({
          'note': {
            'nominative': 'Ramka',
            'genitive': 'Ramki'
          }
        })

        pantry = book_with_notes.pantry(name: :nominative_link_text)
        expect(pantry).to receive(:store).with('Ramka Two Important Limits', { label: 'note_id15' })

        pantry = book_with_notes.pantry(name: :genitive_link_text)
        expect(pantry).to receive(:store).with('Ramki Two Important Limits', { label: 'note_id15' })
        described_class.v1(book: book_with_notes, classes: %w[foo hello theorem], cases: true)
      end
    end
  end
end
