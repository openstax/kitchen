# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeExercises::EOB do

  let(:book1) do
    book_containing(html:
      <<~HTML
        #{metadata(title: 'Book Title')}
        <div data-type="chapter">
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">Chapter 1 Title</h1>
            <span data-type="binding" data-value="translucent"></span>
          </div>
          <h1 data-type="document-title">Chapter 1 Title</h1>
          <div data-type="page" id="m68760" class="introduction" data-cnxml-to-html-ver="1.7.3"></div>
          <div data-type="page" id="m68761" data-cnxml-to-html-ver="1.7.3">
            #{metadata(title: 'Page 1 Title')}
            <div data-type="document-title" id="auto_m68761_72010">Page 1 Title</div>
            <section data-depth="1" id="auto_m68761_fs-idp29893056" class="section-exercises">
              <h3 data-type="title">Calculus End of Chapter Exercises</h3>
              <div data-type="exercise" id="auto_m68761_fs-idp113763312">
                <div data-type="problem" id="auto_m68761_fs-idp26515120">
                  <span class="os-number">1.1</span>
                  <p id="auto_m68761_fs-idm51965232">Problem 1</p>
                </div>
                <div data-type="solution" id="auto_m68761_fs-idp28518832">
                  <span class="os-number">1.1</span>
                  <p id="auto_m68761_fs-idp139010576">Solution 1</p>
                </div>
              </div>
              <div data-type="exercise" id="auto_m68761_fs-idp56789136">
                <div data-type="problem" id="auto_m68761_fs-idm24701936">
                  <span class="os-number">1.1</span>
                  <p id="auto_m68761_fs-idp57923840">Problem 2</p>
                </div>
              </div>
              <div data-type="exercise" id="auto_m68761_fs-idm25346224">
                <div data-type="problem" id="auto_m68761_fs-idp29743712">
                  <span class="os-number">1.1</span>
                  <p id="auto_m68761_fs-idm23990224">Problem 3</p>
                </div>
                <div data-type="solution" id="auto_m68761_fs-idm71693776">
                  <span class="os-number">1.1</span>
                  <p id="auto_m68761_fs-idm7102688">Solution 3</p>
                </div>
              </div>
            </section>
          </div>
          <div data-type="page" id="m68764" data-cnxml-to-html-ver="1.7.3">
            #{metadata(title: 'Page 2 Title')}
            <div data-type="document-title" id="auto_m68764_28725">Page 2 Title</div>
            <section data-depth="1" id="auto_m68764_fs-idm81325184" class="review-exercises">
              <h3 data-type="title">2 Chapter Exercises</h3>
              <div data-type="exercise" id="auto_m68764_fs-idm178529488">
                <div data-type="problem" id="auto_m68764_fs-idp20517968">
                <span class="os-number">1.1</span>
                  <p id="auto_m68764_fs-idm197064800">Problem 4</p>
                </div>
              </div>
              <div data-type="exercise" id="auto_m68764_fs-idm82765632">
                <div data-type="problem" id="auto_m68764_fs-idp7685184">
                  <span class="os-number">1.1</span>
                  <p id="auto_m68764_fs-idm164104512">Problem 5</p>
                </div>
                <div data-type="solution" id="auto_m68764_fs-idm128797504">
                  <span class="os-number">1.1</span>
                  <p id="auto_m68764_fs-idm152759136">Solution 5</p>
                </div>
              </div>
            </section>
          </div>
          <div data-type="page" id="m68769" data-cnxml-to-html-ver="1.7.3">
            #{metadata(title: 'Page 3 Title')}
            <div data-type="document-title" id="auto_m68764_28725">Page 3 Title</div>
            <div class="checkpoint" data-type="note" id="auto_m68764_fs-idm11125184">
              <h3 data-type="title">3 Chapter Exercises</h3>
              <div data-type="exercise" id="auto_m68764_fs-idm178529488">
                <div data-type="problem" id="auto_m68764_fs-idp20517968">
                  <span class="os-number">1.1</span>
                  <p id="auto_m68764_fs-idm197064800">Problem 6</p>
                </div>
              </div>
              <div data-type="exercise" id="auto_m68764_fs-idm82765111">
                <div data-type="problem" id="auto_m68764_fs-idp7685111">
                  <span class="os-number">1.1</span>
                  <p id="auto_m68764_fs-idm164104512">Problem 7</p>
                </div>
                <div data-type="solution" id="auto_m68764_fs-idm128797504">
                  <span class="os-number">1.1</span>
                  <p id="auto_m68764_fs-idm152759111">Solution 7</p>
                </div>
              </div>
            </section>
          </div>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(book: book1, class_names: {
      'checkpoint': '.checkpoint',
      'section_exercises': 'section.section-exercises',
      'review_exercises': 'section.review-exercises'
    })

    expect(book1.body).to match_normalized_html(
      <<~HTML
        <body>
          #{metadata(title: 'Book Title')}
          <div data-type="chapter">
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Chapter 1 Title</h1>
              <span data-type="binding" data-value="translucent"></span>
            </div>
            <h1 data-type="document-title">Chapter 1 Title</h1>
            <div data-type="page" id="m68760" class="introduction" data-cnxml-to-html-ver="1.7.3"></div>
            <div data-type="page" id="m68761" data-cnxml-to-html-ver="1.7.3">
              #{metadata(title: 'Page 1 Title')}
              <div data-type="document-title" id="auto_m68761_72010">Page 1 Title</div>
              <section data-depth="1" id="auto_m68761_fs-idp29893056" class="section-exercises">
                  <h3 data-type="title">Calculus End of Chapter Exercises</h3>
                  <div data-type="exercise" id="auto_m68761_fs-idp113763312">
                    <div data-type="problem" id="auto_m68761_fs-idp26515120">
                      <span class="os-number">1</span>
                      <p id="auto_m68761_fs-idm51965232">Problem 1</p>
                    </div>
                  </div>
                  <div data-type="exercise" id="auto_m68761_fs-idp56789136">
                    <div data-type="problem" id="auto_m68761_fs-idm24701936">
                      <span class="os-number">1.1</span>
                      <p id="auto_m68761_fs-idp57923840">Problem 2</p>
                    </div>
                  </div>
                  <div data-type="exercise" id="auto_m68761_fs-idm25346224">
                    <div data-type="problem" id="auto_m68761_fs-idp29743712">
                      <span class="os-number">3</span>
                      <p id="auto_m68761_fs-idm23990224">Problem 3</p>
                    </div>
                  </div>
              </section>
            </div>
            <div data-type="page" id="m68764" data-cnxml-to-html-ver="1.7.3">
              #{metadata(title: 'Page 2 Title')}
              <div data-type="document-title" id="auto_m68764_28725">Page 2 Title</div>
              <section data-depth="1" id="auto_m68764_fs-idm81325184" class="review-exercises">
                  <h3 data-type="title">2 Chapter Exercises</h3>
                  <div data-type="exercise" id="auto_m68764_fs-idm178529488">
                    <div data-type="problem" id="auto_m68764_fs-idp20517968">
                      <span class="os-number">1.1</span>
                      <p id="auto_m68764_fs-idm197064800">Problem 4</p>
                    </div>
                  </div>
                  <div data-type="exercise" id="auto_m68764_fs-idm82765632">
                    <div data-type="problem" id="auto_m68764_fs-idp7685184">
                      <span class="os-number">2</span>
                      <p id="auto_m68764_fs-idm164104512">Problem 5</p>
                    </div>
                  </div>
              </section>
            </div>
            <div data-type="page" id="m68769" data-cnxml-to-html-ver="1.7.3">
              #{metadata(title: 'Page 3 Title')}
              <div data-type="document-title" id="auto_m68764_28725">Page 3 Title</div>
              <div class="checkpoint" data-type="note" id="auto_m68764_fs-idm11125184">
                <h3 data-type="title">3 Chapter Exercises</h3>
                <div data-type="exercise" id="auto_m68764_fs-idm178529488">
                  <div data-type="problem" id="auto_m68764_fs-idp20517968">
                    <span class="os-number">1.1</span>
                    <p id="auto_m68764_fs-idm197064800">Problem 6</p>
                  </div>
                </div>
                <div data-type="exercise" id="auto_m68764_fs-idm82765111">
                  <div data-type="problem" id="auto_m68764_fs-idp7685111">
                    <span class="os-number">1.2</span>
                    <p id="auto_m68764_fs-idm164104512">Problem 7</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="os-eob os-solutions-container" data-type="composite-chapter" data-uuid-key=".solutions">
            <h1 data-type="document-title" id="composite-chapter-1">
              <span class="os-text">Answer Key</span>
            </h1>
            #{metadata(title: 'Answer Key', id_suffix: '_copy_1')}
            <div class="os-eob os-solution-container" data-type="composite-page" data-uuid-key=".solutions1">
              <h2 data-type="document-title">
                  <span class="os-text">Chapter 1</span>
              </h2>
              #{metadata(title: 'Chapter1', id_suffix: '_copy_1')}
              <div class="os-solution-area">
                <h3 data-type="title">
                  <span class="os-title-label">Checkpoint</span>
                </h3>
                <div data-type="solution" id="auto_m68764_fs-idm82765111-solution">
                  <span class="os-number">1.2</span>
                  <p id="auto_m68764_fs-idm152759111">Solution 7</p>
                </div>
              </div>
              <div class="os-solution-area">
                <h3 data-type="title">
                  <span class="os-title-label">Section 1.1 Exercises</span>
                </h3>
                <div data-type="solution" id="auto_m68761_fs-idp113763312-solution">
                  <span class="os-number">1</span>
                  <p id="auto_m68761_fs-idp139010576">Solution 1</p>
                </div>
                <div data-type="solution" id="auto_m68761_fs-idm25346224-solution">
                  <span class="os-number">3</span>
                  <p id="auto_m68761_fs-idm7102688">Solution 3</p>
                </div>
              </div>
              <div class="os-solution-area">
                <h3 data-type="title">
                  <span class="os-title-label">Review Exercises</span>
                </h3>
                <div data-type="solution" id="auto_m68764_fs-idm82765632-solution">
                  <span class="os-number">2</span>
                  <p id="auto_m68764_fs-idm152759136">Solution 5</p>
                </div>
              </div>
            </div>
          </div>
        </body>
      HTML
    )
  end

  def metadata(title:, id_suffix: '')
    <<~HTML
      <div data-type="metadata" style="display: none;">
        <h1 data-type="document-title" itemprop="name">#{title}</h1>
        <div class="authors">
          <span id="author-1#{id_suffix}" ><a>OpenStaxCollege</a></span>
        </div>
        <div class="publishers">
          <span id="publisher-1#{id_suffix}"><a>OpenStaxCollege</a></span>
        </div>
        <div class="print-style">
          <span data-type="print-style">ccap-chemistry</span>
        </div>
        <div class="permissions">
          <p class="copyright">
            <span id="copyright-holder-1#{id_suffix}"><a>OSCRiceUniversity</a></span>
          </p>
          <p class="license">
            <a>CC BY</a>
          </p>
        </div>
        <div itemprop="about" data-type="subject">Science and Technology</div>
      </div>
    HTML
  end
end
