# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterIntroductions do
  before do
    stub_locales({
      'chapter_outline': 'Chapter Outline',
      'notes': {
        'chapter-objectives': 'Chapter Objectives'
      }
    })
  end

  let(:book_with_diff_order) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <h1 data-type="document-title">Chapter 1 Title</h1>
          <div class="introduction" data-type="page">
            <div data-type="document-title">Introduction</div>
            <figure class="splash">
              <div data-type="title">Blood Pressure</div>
              <figcaption>A proficiency in anatomy and physiology... (credit: Bryan Mason/flickr)</figcaption>
              <span data-type="media" data-alt="This photo shows a nurse taking a woman’s...">
              <img src="ccc4ed14-6c87-408b-9934-7a0d279d853a/100_Blood_Pressure.jpg" data-media-type="image/jpg" alt="This photo shows a nurse taking..." />
              </span>
            </figure>
            <div data-type="note" class="chapter-objectives">
              <div data-type="title">Chapter Objectives</div>
              <p>After studying this chapter, you will be able to:</p>
              <ul>
                <li>Distinguish between anatomy and physiology, and identify several branches of each</li>
              </ul>
            </div>
            <p id="123">Though you may approach a course in anatomy and physiology...</p>
            <p id="123">This chapter begins with an overview of anatomy and...</p>
          </div>
        </div>
      HTML
    )
  end

  let(:book_with_intro_objectives) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div class="introduction" data-type="page">
            <div data-type="document-title">Introduction 1</div>
            <div data-type="description">trash this</div>
            <div data-type="abstract">and this</div>
            <div data-type="metadata">don't touch this</div>
            <figure class="splash">can't touch this (stop! hammer time)</figure>
            <figure>move this</figure>
            <div>content</div>
            <div data-type="note" data-has-label="true" id="1" class="chapter-objectives">
              <div data-type="title">Chapter Objectives</div>
              <p>Some Text</p>
              <ul>
                <li>Some List</li>
              </ul>
            </div>
          </div>
        </div>
      HTML
    )
  end

  context 'when v2 called on book without chapter outline' do
    it 'works' do
      described_class.v2(book: book_with_diff_order, chapter_objectives_strategy: :default)
      expect(book_with_diff_order.body).to match_normalized_html(
        <<~HTML
          <body>
            <div data-type="chapter">
              <h1 data-type="document-title">Chapter 1 Title</h1>
              <div class="introduction" data-type="page">
                <figure class="splash">
                  <div data-type="title">Blood Pressure</div>
                  <figcaption>A proficiency in anatomy and physiology... (credit: Bryan Mason/flickr)</figcaption>
                  <span data-type="media" data-alt="This photo shows a nurse taking a woman&#x2019;s...">
                  <img src="ccc4ed14-6c87-408b-9934-7a0d279d853a/100_Blood_Pressure.jpg" data-media-type="image/jpg" alt="This photo shows a nurse taking..."/>
                  </span>
                </figure>
                <div class="intro-body">
                  <div data-type="note" class="chapter-objectives">
                    <h3 class="os-title" data-type="title">
                      <span class="os-title-label">Chapter Objectives</span>
                    </h3>
                    <div class="os-note-body">
                      <p>After studying this chapter, you will be able to:</p>
                      <ul>
                        <li>Distinguish between anatomy and physiology, and identify several branches of each</li>
                      </ul>
                    </div>
                  </div>
                  <div class="intro-text">
                    <h2 data-type="document-title"><span data-type="" itemprop="" class="os-text">Introduction</span></h2>
                    <p id="123">Though you may approach a course in anatomy and physiology...</p>
                    <p id="123_copy_1">This chapter begins with an overview of anatomy and...</p>
                  </div>
                </div>
              </div>
            </div>
          </body>
        HTML
      )
    end
  end

  context 'when v2 is called on a book with chapter-objectives: preexisting-title' do
    it 'works' do
      described_class.v2(book: book_with_intro_objectives, chapter_objectives_strategy: :default)
      expect(book_with_intro_objectives.body).to match_normalized_html(
        <<~HTML
          <body>
            <div data-type="chapter">
              <div class="introduction" data-type="page">
                <div data-type="metadata">don't touch this</div>
                <figure class="splash">can't touch this (stop! hammer time)</figure>
                <div class="intro-body">
                <div class="chapter-objectives" data-has-label="true" data-type="note" id="1">
                  <h3 class="os-title" data-type="title">
                    <span class="os-title-label">Chapter Objectives</span>
                  </h3>
                  <div class="os-note-body">
                    <p>Some Text</p>
                    <ul>
                      <li>Some List</li>
                    </ul>
                  </div>
                </div>
                <div class="intro-text">
                    <h2 data-type="document-title">
                      <span class="os-text" data-type="" itemprop="">Introduction 1</span>
                    </h2>
                    <figure>move this</figure>
                    <div>content</div>
                  </div>
                </div>
              </div>
            </div>
          </body>
        HTML
      )
    end
  end

  context 'when v2 is called on a book with chapter-objectives strategy: ' do
    it 'none works' do
      described_class.v2(book: book_with_intro_objectives, chapter_objectives_strategy: :none)
      expect(book_with_intro_objectives.body).to match_normalized_html(
        <<~HTML
          <body>
            <div data-type="chapter">
              <div class="introduction" data-type="page">
                <div data-type="metadata">don't touch this</div>
                <figure class="splash">can't touch this (stop! hammer time)</figure>
                <div class="intro-body">
                <div class="chapter-objectives" data-has-label="true" data-type="note" id="1">
                  <div data-type="title">Chapter Objectives</div>
                  <p>Some Text</p>
                  <ul>
                    <li>Some List</li>
                  </ul>
                </div>
                <div class="intro-text">
                    <h2 data-type="document-title">
                      <span class="os-text" data-type="" itemprop="">Introduction 1</span>
                    </h2>
                    <figure>move this</figure>
                    <div>content</div>
                  </div>
                </div>
              </div>
            </div>
          </body>
        HTML
      )
    end

    it 'other raises' do
      expect {
        described_class.v2(book: book_with_intro_objectives, chapter_objectives_strategy: :hello)
      }.to raise_error('No such strategy')
    end
  end

end
