# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::MoveSolutionsToAnswerKey::V1 do
  before do
    stub_locales({
      'chapter': 'Chapter',
      'eoc': {
        'section-quiz': 'Section Quiz'
      },
      'eoc_answer_key_title': 'Answer Key'
    })
  end

  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">Chapter 1 Title</h1>
            <span data-type="binding" data-value="translucent"></span>
          </div>
          <h1 data-type="document-title">Chapter 1 Title</h1>
          <div data-type="page">
            <section class="section-quiz">
              <div data-type="exercise">
                <div data-type="problem">
                  <span class="os-number">1</span>
                  <p>Problem 1</p>
                </div>
                <div data-type="solution">
                  <span class="os-number">1</span>
                  <p>Solution 1</p>
                </div>
              </div>
              <div data-type="exercise">
                <div data-type="problem">
                  <span class="os-number">2</span>
                  <p>Problem 2</p>
              </div>
                <div data-type="solution">
                  <span class="os-number">2</span>
                  <p>Solution 2</p>
                </div>
              </div>
              <div data-type="exercise">
                <div data-type="problem">
                  <span class="os-number">3</span>
                  <p>Problem 3</p>
              </div>
                <div data-type="solution">
                  <span class="os-number">3</span>
                  <p>Solution 3</p>
                </div>
              </div>
            </section>
          </div>
        </div>
        <div data-type="chapter">
          <h1 data-type="document-title">Chapter 2 Title</h1>
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">Chapter 2 Title</h1>
            <span data-type="binding" data-value="translucent"></span>
          </div>
          <div data-type="page">
            <section class="section-quiz">
              <div data-type="exercise">
                <div data-type="problem">
                  <span class="os-number">1</span>
                  <p>Problem 1</p>
                </div>
                <div data-type="solution">
                  <span class="os-number">1</span>
                  <p>Solution 1</p>
                </div>
              </div>
            </section>
            <section class="section-quiz">
              <div data-type="exercise">
                <div data-type="problem">
                  <span class="os-number">2</span>
                  <p>Problem 2</p>
                </div>
                <div data-type="solution">
                  <span class="os-number">2</span>
                  <p>Solution 2</p>
                </div>
              </div>
            </section>
          </div>
        </div>
      HTML
    )
  end

  let(:answer_key_container) do
    new_element(
      <<~HTML
        <div class="os-eob os-solution-container" data-type="composite-chapter" data-uuid-key=".solution">
          <h1 data-type="document-title" id="composite-chapter-1">
            <span class="os-text">#{I18n.t(:eoc_answer_key_title)}</span>
          </h1>
        </div>
      HTML
    )
  end

  it 'works' do
    book1.chapters.each do |chapter|
      described_class.new.bake(
        chapter: chapter,
        metadata_source: metadata_element,
        strategy: :sociology,
        klass: 'solution',
        append_to: answer_key_container
      )
    end

    expect(answer_key_container).to match_normalized_html(
      <<~HTML
        <div class="os-eob os-solution-container" data-type="composite-chapter" data-uuid-key=".solution">
          <h1 data-type="document-title" id="composite-chapter-1">
            <span class="os-text">Answer Key</span>
          </h1>
          <div class="os-eob os-solution-container" data-type="composite-page" data-uuid-key=".solution1">
            <h2 data-type="document-title">
              <span class="os-text">Chapter 1</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Chapter 1</h1>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
              </div>
            <div data-type="solution">
                <span class="os-number">1</span>
                <p>Solution 1</p>
            </div>
            <div data-type="solution">
                <span class="os-number">2</span>
                <p>Solution 2</p>
              </div>
            <div data-type="solution">
              <span class="os-number">3</span>
              <p>Solution 3</p>
            </div>
          </div>
          <div class="os-eob os-solution-container" data-type="composite-page" data-uuid-key=".solution2">
            <h2 data-type="document-title">
              <span class="os-text">Chapter 2</span>
            </h2>
            <div data-type="metadata" style="display: none;">
             <h1 data-type="document-title" itemprop="name">Chapter 2</h1>
             <div class="authors" id="authors_copy_1">Authors</div>
             <div class="publishers" id="publishers_copy_1">Publishers</div>
             <div class="print-style" id="print-style_copy_1">Print Style</div>
             <div class="permissions" id="permissions_copy_1">Permissions</div>
             <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <div data-type="solution">
                <span class="os-number">1</span>
                <p>Solution 1</p>
            </div>
            <div data-type="solution">
                <span class="os-number">2</span>
                <p>Solution 2</p>
            </div>
          </div>
        </div>
      HTML
    )
  end

  it 'raises error if it does not find a strategy ' do
    expect {
      described_class.new.bake(
        chapter: book1.chapters.first,
        metadata_source: metadata_element,
        strategy: :social,
        klass: 'solution',
        append_to: answer_key_container
      )
    }.to raise_error('No such strategy')
  end

  # def metadata(title:, id_suffix: '')
  #   <<~HTML
  #     <div data-type="metadata" style="display: none;">
  #       <h1 data-type="document-title" itemprop="name">#{title}</h1>
  #       <div class="authors">
  #         <span id="author-1#{id_suffix}" ><a>OpenStaxCollege</a></span>
  #       </div>
  #       <div class="publishers">
  #         <span id="publisher-1#{id_suffix}"><a>OpenStaxCollege</a></span>
  #       </div>
  #       <div class="print-style">
  #         <span data-type="print-style">sociology-prod</span>
  #       </div>
  #       <div class="permissions">
  #         <p class="copyright">
  #           <span id="copyright-holder-1#{id_suffix}"><a>OSCRiceUniversity</a></span>
  #         </p>
  #         <p class="license">
  #           <a>CC BY</a>
  #         </p>
  #       </div>
  #       <div itemprop="about" data-type="subject">Social Sciences</div>
  #     </div>
  #   HTML
  # end
end
