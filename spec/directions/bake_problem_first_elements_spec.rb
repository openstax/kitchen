# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeProblemFirstElements do
  let(:book) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="exercise" id="bla1">
            <div data-type="problem" id="bla2">
              <span class="os-number">28</span>
              <span class="os-divider">. </span>
              <div class="os-problem-container">
                <span data-alt="An image ..." data-type="media" id="bla3">
                  <img alt="some text" data-media-type="image/jpeg" id="bla4" src="bla.jpg" />
                  <p>do not bake me</p>
                </span>
              </div>
            </div>
          </div>
          <section class="section-exercises" id="sectionId">
            <p id="bla5">For the following exercises...</p>
            <div class="os-hasSolution" data-type="exercise" id="bla6">
              <div data-type="problem" id="bla7">
                <a class="os-number" href="#bla11">1</a>
                <span class="os-divider">. </span>
                <div class="os-problem-container">
                  <div class="os-table">
                    <table class="unnumbered" data-label="" id="bla8">
                      <p>some content</p>
                    </table>
                  </div>
                </div>
              </div>
            </div>
            <div data-type="exercise" id="bla1">
              <div data-type="problem" id="bla2">
                <span class="os-number">28</span>
                <span class="os-divider">. </span>
                <div class="os-problem-container">
                  <span data-alt="An image..." data-type="media" id="bla3">
                    <img alt="some text" data-media-type="image/jpeg" id="bla4" src="bla.jpg" />
                  </span>
                </div>
              </div>
            </div>
            <div data-type="exercise" id="bla1">
              <div data-type="problem" id="bla2">
                <div class="os-problem-container">
                  <span data-alt="An image..." data-type="media" id="bla3">
                    <p>something</p>
                  </span>
                </div>
              </div>
            </div>
            <div data-type="exercise" id="bla6">
              <div data-type="problem" id="bla7">
                <span class="os-number">22</span>
                <span class="os-divider">. </span>
                <div class="os-problem-container">
                  <p id="bla8">
                    <span class="os-math-in-para">
                      <p>some content</p>
                    </span>
                  </p>
                  <div class="os-table">
                    <table class="unnumbered" data-label="" id="bla9">
                      <div>do not bake this content</div>
                    </table>
                  </div>
                </div>
              </div>
            </div>
          </section>
        HTML
      )
    )
  end

  it 'works' do
    within = book.search('.section-exercises').first
    described_class.v1(
      within: within,
      selectors: ['.os-problem-container > .os-table', '.os-problem-container > [data-type="media"]']
    )

    expect(book.body).to match_normalized_html(
      <<~HTML
        <body>
          <div data-type="chapter">
            <div data-type="page">
              <div data-type="exercise" id="bla1">
                <div data-type="problem" id="bla2">
                  <span class="os-number">28</span>
                  <span class="os-divider">. </span>
                  <div class="os-problem-container">
                    <span data-alt="An image ..." data-type="media" id="bla3">
                      <img alt="some text" data-media-type="image/jpeg" id="bla4" src="bla.jpg"/>
                      <p>do not bake me</p>
                    </span>
                  </div>
                </div>
              </div>
              <section class="section-exercises" id="sectionId">
                <p id="bla5">For the following exercises...</p>
                <div class="os-hasSolution" data-type="exercise" id="bla6">
                  <div data-type="problem" id="bla7">
                    <a class="os-number" href="#bla11">1</a>
                    <span class="os-divider">. </span>
                    <div class="os-problem-container has-first-element">
                      <div class="os-table first-element">
                        <table class="unnumbered" data-label="" id="bla8">
                          <p>some content</p>
                        </table>
                      </div>
                    </div>
                  </div>
                </div>
                <div data-type="exercise" id="bla1">
                  <div data-type="problem" id="bla2">
                    <span class="os-number">28</span>
                    <span class="os-divider">. </span>
                    <div class="os-problem-container has-first-element">
                      <span data-alt="An image..." data-type="media" id="bla3" class="first-element">
                        <img alt="some text" data-media-type="image/jpeg" id="bla4" src="bla.jpg"/>
                      </span>
                    </div>
                  </div>
                </div>
                <div data-type="exercise" id="bla1">
                  <div data-type="problem" id="bla2">
                    <div class="os-problem-container has-first-element">
                      <span data-alt="An image..." data-type="media" id="bla3" class="first-element">
                        <p>something</p>
                      </span>
                    </div>
                  </div>
                </div>
                <div data-type="exercise" id="bla6">
                  <div data-type="problem" id="bla7">
                    <span class="os-number">22</span>
                    <span class="os-divider">. </span>
                    <div class="os-problem-container">
                      <p id="bla8">
                        <span class="os-math-in-para">
                      <p>some content</p>
                      </span>
                      </p>
                      <div class="os-table">
                        <table class="unnumbered" data-label="" id="bla9">
                          <div>do not bake this content</div>
                        </table>
                      </div>
                    </div>
                  </div>
                </div>
              </section>
            </div>
          </div>
        </body>
      HTML
    )
  end
end