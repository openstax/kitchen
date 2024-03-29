# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::DefaultStrategyForAnswerKeySolutions do
  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <h1 data-type="document-title">Title for Ch1</h1>
          <div data-type="page">
            <section id="1234" class="review-questions">
              <div data-type="exercise">
                <div data-type="problem">Problem 1>Blah</div>
                <div data-type="solution">a</div>
              </div>
              <div data-type="exercise">
                <div data-type="problem">Problem 1>Blork</div>
                <div data-type="solution">b</div>
              </div>
            </section>
          </div>
        </div>
        <div data-type="chapter">
          <h1 data-type="document-title">Title for Ch2</h1>
          <div data-type="page">
            <section id="5679" class="review-questions">
              <div data-type="exercise">
                <div data-type="problem">Problem 1>Beep</div>
                <div data-type="solution">c</div>
              </div>
              <div data-type="exercise">
                <div data-type="problem">Problem 1>Voom</div>
                <div data-type="solution">d</div>
              </div>
            </section>
          </div>
        </div>
      HTML
    )
  end

  let(:append_to) do
    new_element(
      <<~HTML
        <div class="bleepbloop"></div>
      HTML
    )
  end

  it 'works' do
    book1.chapters.each do |chapter|
      described_class.v1(
        strategy_options: { selectors: %w[section.review-questions] },
        chapter: chapter,
        append_to: append_to
      )
    end

    expect(append_to).to match_normalized_html(
      <<~HTML
        <div class="bleepbloop">
          <div data-type="solution">a</div>
          <div data-type="solution">b</div>
          <div data-type="solution">c</div>
          <div data-type="solution">d</div>
        </div>
      HTML
    )
  end
end
