# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeExercises::InPlace do
  let(:book) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="example" id="example_id">
            <div data-type="exercise" id="exercise_id">
              <div data-type="problem" id="problem_id">
                <div data-type="title" id="title_id">Evaluating Functions</div>
                <p>example content</p>
              </div>
              <div data-type="solution" id="solution_id">
                <p>Solution content</p>
              </div>
            </div>
          </div>

          <div data-type="note" id="note_id" class="checkpoint">
            <div data-type="exercise" id="exercise_id">
              <div data-type="problem" id="problem_id">
                <p> problem content </p>
              </div>
              <div data-type="solution" id="solution_id">
                <p> solution content </p>
              </div>
              <div data-type="commentary" id="" data-element-type="hint">
                <div data-type="title" id="bla">Hint</div>
                <p> comment </p>
              </div>
            </div>
          </div>

          <section data-depth="1" id="section_id" class="section-exercises">
            <p id="id">A text</p>
            <div data-type="exercise" id="exercise_id">
              <div data-type="problem" id="problem_id">
                <p> problem content </p>
              </div>
              <div data-type="solution" id="solution_id">
                <p id="id2"></p>
              </div>
            </div>
          </section>
        HTML
      )
    )
  end

  it 'bakes note exercises' do
    note = book.notes.first
    exercise = note.exercises.first
    described_class.new.note_exercises(exercise: exercise)
    expect(book.notes).to match_normalized_html(
      <<~HTML
        <div data-type="note" id="note_id" class="checkpoint">
          <div data-type="exercise" id="exercise_id" class="os-hasSolution unnumbered">
            <div data-type="problem" id="problem_id">
              <div class="os-problem-container ">
                <p> problem content </p>
              </div>
            </div>
            <div data-type="solution" id="exercise_id-solution">
              <p> solution content </p>
            </div>
            <div data-type="commentary" id="" data-element-type="hint">
              <div data-type="title" id="bla">Hint</div>
              <p> comment </p>
            </div>
          </div>
        </div>
      HTML
    )
  end

  it 'bakes section exercises' do
    section = book.search('section.section-exercises').first
    exercise = section.exercises.first
    described_class.new.section_exercises(exercise: exercise, number: '1.1')

    expect(section).to match_normalized_html(
      <<~HTML
        <section data-depth="1" id="section_id" class="section-exercises">
          <p id="id">A text</p>
          <div data-type="exercise" id="exercise_id" class="os-hasSolution">
            <div data-type="problem" id="problem_id">
              <a class="os-number" href="#exercise_id-solution">1.1</a>
              <span class="os-divider">. </span>
              <div class="os-problem-container">
                <p> problem content </p>
              </div>
            </div>
            <div data-type="solution" id="solution_id"><a class="os-number" href="#exercise_id">1.1</a>
              <span class="os-divider">. </span>
              <div class="os-solution-container ">
                <p id="id2"/>
              </div>
            </div>
          </div>
        </section>
      HTML
    )
  end
end
