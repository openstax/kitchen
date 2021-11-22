# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedExercise do

  eoc_sections_prefixed =
    {
      'multiple-choice' => nil,
      'questions' => nil,
      'exercise-set-a' => 'EA',
      'exercise-set-b' => 'EB',
      'problem-set-a' => 'PA',
      'problem-set-b' => 'PB',
      'thought-provokers' => 'TP'
    }

  let(:exercise1) do
    book_containing(html:
      one_chapter_with_one_composite_page_containing(
        <<~HTML
          <section class="multiple-choice">
            <div data-type="exercise" id="exercise_id">
              <div data-type="problem" id="problem_id">
                <p>example content</p>
              </div>
              <div data-type="solution" id="solution_id">
                <p>Solution content</p>
              </div>
            </div>
          </section>
          <section class="questions">
            <div data-type="exercise" id="exercise_id">
              <div data-type="problem" id="problem_id">
                <p>example content</p>
              </div>
              <div data-type="solution" id="solution_id">
                <p>Solution content</p>
              </div>
            </div>
          </section>
          <section class="exercise-set-a">
            <div data-type="exercise" id="exercise_id">
              <div data-type="problem" id="problem_id">
                <p>example content</p>
              </div>
            </div>
          </section>
          <section class="exercise-set-b">
            <div data-type="exercise" id="exercise_id">
              <div data-type="problem" id="problem_id">
                <p>example content</p>
              </div>
            </div>
          </section>
          <section class="problem-set-a">
            <div data-type="exercise" id="exercise_id">
              <div data-type="problem" id="problem_id">
                <p>example content</p>
              </div>
            </div>
          </section>
          <section class="problem-set-b">
            <div data-type="exercise" id="exercise_id">
              <div data-type="problem" id="problem_id">
                <p>example content</p>
              </div>
            </div>
          </section>
          <section class="thought-provokers">
            <div data-type="exercise" id="exercise_id">
              <div data-type="problem" id="problem_id">
                <p>example content</p>
              </div>
            </div>
          </section>
        HTML
      )
    ).chapters.first.composite_pages.first
  end

  eoc_sections_prefixed.each do |section_key, prefix|
    exercise1.search("section.#{section_key}").each do |exercise|
      it 'works' do
        described_class.v2(exercise: exercise, number: '1.1', prefix: prefix)
        expect(exercise1).to match_normalized_html(
          <<~HTML
            <section class="multiple-choice">
              <div data-type="exercise" id="exercise_id" class="os-hasSolution">
                <div data-type="problem" id="problem_id">
                  <a class="os-number" href="#exercise_id-solution">1.1</a>
                  <span class="os-divider">. </span>
                  <div class="os-problem-container">
                    <p>example content</p>
                  </div>
                </div>
                <div data-type="solution" id="exercise_id-solution"><a class="os-number" href="#exercise_id">1.1</a>
                  <span class="os-divider">. </span>
                  <div class="os-solution-container">
                    <p>Solution content</p>
                  </div>
                </div>
              </div>
            </section>
            <section class="questions">
              <div data-type="exercise" id="exercise_id" class="os-hasSolution">
                <div data-type="problem" id="problem_id">
                  <a class="os-number" href="#exercise_id-solution">1.1</a>
                  <span class="os-divider">. </span>
                  <div class="os-problem-container">
                    <p>example content</p>
                  </div>
                </div>
                <div data-type="solution" id="exercise_id-solution"><a class="os-number" href="#exercise_id">1.1</a>
                  <span class="os-divider">. </span>
                  <div class="os-solution-container">
                    <p>Solution content</p>
                  </div>
                </div>
              </div>
            </section>
            <section class="exercise-set-a">
              <div data-type="exercise" id="exercise_id">
                <div data-type="problem" id="problem_id">
                  <span class="os-text">EA</span>
                  <span class="os-number">1.1</>
                  <span class="os-divider">. </span>
                  <div class="os-problem-container">
                    <p>example content</p>
                  </div>
                </div>
              </div>
            </section>
            <section class="exercise-set-b">
              <div data-type="exercise" id="exercise_id">
                <div data-type="problem" id="problem_id">
                  <span class="os-text">EB</span>
                  <span class="os-number">1.1</>
                  <span class="os-divider">. </span>
                  <div class="os-problem-container">
                    <p>example content</p>
                  </div>
                </div>
              </div>
            </section>
            <section class="exercise-problem-a">
              <div data-type="exercise" id="exercise_id">
                <div data-type="problem" id="problem_id">
                  <span class="os-text">PA</span>
                  <span class="os-number">1.1</>
                  <span class="os-divider">. </span>
                  <div class="os-problem-container">
                    <p>example content</p>
                  </div>
                </div>
              </div>
            </section>
            <section class="exercise-problem-b">
              <div data-type="exercise" id="exercise_id">
                <div data-type="problem" id="problem_id">
                  <span class="os-text">PB</span>
                  <span class="os-number">1.1</>
                  <span class="os-divider">. </span>
                  <div class="os-problem-container">
                    <p>example content</p>
                  </div>
                </div>
              </div>
            </section>
            <section class="thought-provokers">
              <div data-type="exercise" id="exercise_id">
                <div data-type="problem" id="problem_id">
                  <span class="os-text">TP</span>
                  <span class="os-number">1.1</>
                  <span class="os-divider">. </span>
                  <div class="os-problem-container">
                    <p>example content</p>
                  </div>
                </div>
              </div>
            </section>
          HTML
        )
      end
    end
  end
end
