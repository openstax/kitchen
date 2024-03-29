# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeAutotitledExercise do

  before do
    stub_locales({
      'exercises': {
        'your-turn': 'Your Turn',
        'solution': 'Solution'
      }
    })
  end

  let(:exercise1) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="exercise" id="1" class="your-turn">
            <div data-type="problem" id="456">
              <ul id="920">
                <li>You are trading stocks on the Internet;</li>
                <li>Second Your Turn question goes here.</li>
              </ul>
            </div>
            <div data-type="solution" id="24">
              <p id="456">WW-test We need to finalize where the solution would appear.</p>
            </div>
          </div>
        HTML
      )
    ).chapters.exercises.first
  end

  let(:exercise2) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="exercise" id="1" class="homework">
            <div data-type="problem" id="456">
              <ul id="920">
                <li>This is a list</li>
              </ul>
            </div>
            <div data-type="solution" id="24">
              <p id="456">answer</p>
            </div>
          </div>
        HTML
      )
    ).chapters.exercises.first
  end

  it 'bakes' do
    described_class.v1(exercise: exercise1)

    expect(exercise1).to match_normalized_html(
      <<~HTML
        <div class="your-turn unnumbered" data-type="exercise" id="1">
          <div data-type="problem" id="456">
            <h4 class="exercise-title" data-type="title">Your Turn</h4>
            <div class="os-problem-container">
              <ul id="920">
                <li>You are trading stocks on the Internet;</li>
                <li>Second Your Turn question goes here.</li>
              </ul>
            </div>
          </div>
          <div data-type="solution" id="24">
            <h4 class="solution-title" data-type="title">
              <span class="os-text">Solution</span>
            </h4>
            <div class="os-solution-container">
              <p id="456">WW-test We need to finalize where the solution would appear.</p>
            </div>
          </div>
        </div>
      HTML
    )
  end

  it 'does not crash when autogenerated title is not available' do
    described_class.v1(exercise: exercise2)

    expect(exercise2).to match_normalized_html(
      <<~HTML
        <div class="homework unnumbered" data-type="exercise" id="1">
          <div data-type="problem" id="456">
            <h4 class="exercise-title" data-type="title">unknown title for exercise with classes ["homework", "unnumbered"]</h4>
            <div class="os-problem-container">
              <ul id="920">
                <li>This is a list</li>
              </ul>
            </div>
          </div>
          <div data-type="solution" id="24">
            <h4 class="solution-title" data-type="title">
              <span class="os-text">Solution</span>
            </h4>
            <div class="os-solution-container">
              <p id="456">answer</p>
            </div>
          </div>
        </div>
      HTML
    )
  end
end
