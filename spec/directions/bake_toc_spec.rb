# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeToc do
  before do
    stub_locales({
      'toc_title': 'Contents',
      'chapter': 'Chapter',
      'unit': 'Unit'
    })
  end

  let(:book_unit) do
    book_containing(html:
      <<~HTML
        <nav id="toc"></nav>
        <div data-type="page" id="p1" class="preface">
          <h1 data-type="document-title">
            <span data-type="" itemprop="" class="os-text">Preface</span>
          </h1>
        </div>
        <div data-type="unit">
          <h1 data-type="document-title">Unit 1 Title</h1>
          <div data-type="chapter">
            <h1 data-type="document-title" id="chapTitle1">
              <span class="os-part-text">Chapter </span>
              <span class="os-number">1</span>
              <span class="os-divider"> </span>
              <span class="os-text" data-type="" itemprop="">Chapter 1 Title</span>
            </h1>
            <div data-type="page" class="introduction" id="p2">
              <div class="intro-body">
                <div class="intro-text">
                  <h2 data-type="document-title" id="auto_m68760_38230">
                    <span data-type="" itemprop="" class="os-text">Introduction</span>
                  </h2>
                </div>
              </div>
            </div>
            <div data-type="page" id="p3">
              <h2 data-type="document-title">
                <span class="os-number">1.1</span>
                <span class="os-divider"> </span>
                <span data-type="" itemprop="" class="os-text">Page 1.1 Title</span>
              </h2>
            </div>
            <div data-type="composite-page" id="composite-page-1">
              <h2 data-type="document-title">
                <span class="os-text">Key Terms</span>
              </h2>
            </div>
          </div>
          <div data-type="chapter">
            <h1 data-type="document-title" id="chapTitle2">
              <span class="os-part-text">Chapter </span>
              <span class="os-number">2</span>
              <span class="os-divider"> </span>
              <span class="os-text" data-type="" itemprop="">Chapter 2 Title</span>
            </h1>
            <div data-type="page" id="p4">
              <h2 data-type="document-title">
                <span class="os-number">2.1</span>
                <span class="os-divider"> </span>
                <span data-type="" itemprop="" class="os-text">Page 2.1 Title</span>
              </h2>
            </div>
          </div>
        </div>
        <div data-type="unit">
          <h1 data-type="document-title">Unit 2 Title</h1>
          <div data-type="chapter">
            <h1 data-type="document-title" id="chapTitle3">
              <span class="os-part-text">Chapter </span>
              <span class="os-number">3</span>
              <span class="os-divider"> </span>
              <span class="os-text" data-type="" itemprop="">Chapter 3 Title</span>
            </h1>
            <div data-type="page" class="introduction" id="p5">
              <div class="intro-body">
                <div class="intro-text">
                  <h2 data-type="document-title" id="auto_m68760_38230">
                    <span data-type="" itemprop="" class="os-text">Introduction</span>
                  </h2>
                </div>
              </div>
            </div>
            <div data-type="page" id="p6">
              <h2 data-type="document-title">
                <span class="os-number">3.1</span>
                <span class="os-divider"> </span>
                <span data-type="" itemprop="" class="os-text">Page 3.1 Title</span>
              </h2>
            </div>
            <div data-type="composite-page" id="composite-page-2">
              <h2 data-type="document-title">
                <span class="os-text">Key Terms</span>
              </h2>
            </div>
          </div>
        </div>
        <div data-type="page" id="p7" class="appendix">
          <h1 data-type="document-title">
            <span class="os-part-text">Appendix </span>
            <span class="os-number">A</span>
            <span class="os-divider"> </span>
            <span data-type="" itemprop="" class="os-text">Appendix A Title</span>
          </h1>
        </div>
        <div data-type="composite-chapter">
          <h1 data-type="document-title" id="composite-chapter-1">
            <span class="os-text">Answer Key</span>
          </h1>
          <div data-type="composite-page" id="p8">
            <h2 data-type="document-title">
              <span class="os-text">Chapter 1</span>
            </h2>
          </div>
        </div>
        <div class="os-index-container" data-type="composite-page" id="p9">
          <h1 data-type="document-title">
            <span class="os-text">Index</span>
          </h1>
        </div>
      HTML
    ).tap do |book|
      # TOC runs after introduction baking which changes some selectors
      Kitchen::Directions::BakeChapterIntroductions.v1_update_selectors(book)
    end
  end

  let(:book_no_unit) do
    book_containing(html:
      <<~HTML
        <nav id="toc"></nav>
        <div data-type="page" id="p1" class="preface">
          <h1 data-type="document-title">
            <span data-type="" itemprop="" class="os-text">Preface</span>
          </h1>
        </div>
          <div data-type="chapter">
            <h1 data-type="document-title" id="chapTitle1">
              <span class="os-part-text">Chapter </span>
              <span class="os-number">1</span>
              <span class="os-divider"> </span>
              <span class="os-text" data-type="" itemprop="">Chapter 1 Title</span>
            </h1>
            <div data-type="page" class="introduction" id="p2">
              <div class="intro-body">
                <div class="intro-text">
                  <h2 data-type="document-title" id="auto_m68760_38230">
                    <span data-type="" itemprop="" class="os-text">Introduction</span>
                  </h2>
                </div>
              </div>
            </div>
            <div data-type="page" id="p3">
              <h2 data-type="document-title">
                <span class="os-number">1.1</span>
                <span class="os-divider"> </span>
                <span data-type="" itemprop="" class="os-text">Page 1.1 Title</span>
              </h2>
            </div>
            <div data-type="composite-page" id="composite-page-1">
              <h2 data-type="document-title">
                <span class="os-text">Key Terms</span>
              </h2>
            </div>
          </div>
          <div data-type="chapter">
            <h1 data-type="document-title" id="chapTitle2">
              <span class="os-part-text">Chapter </span>
              <span class="os-number">2</span>
              <span class="os-divider"> </span>
              <span class="os-text" data-type="" itemprop="">Chapter 2 Title</span>
            </h1>
            <div data-type="page" id="p4">
              <h2 data-type="document-title">
                <span class="os-number">2.1</span>
                <span class="os-divider"> </span>
                <span data-type="" itemprop="" class="os-text">Page 2.1 Title</span>
              </h2>
            </div>
          </div>
        <div data-type="page" id="p5" class="appendix">
          <h1 data-type="document-title">
            <span class="os-part-text">Appendix </span>
            <span class="os-number">A</span>
            <span class="os-divider"> </span>
            <span data-type="" itemprop="" class="os-text">Appendix A Title</span>
          </h1>
        </div>
        <div data-type="composite-chapter">
          <h1 data-type="document-title" id="composite-chapter-1">
            <span class="os-text">Answer Key</span>
          </h1>
          <div data-type="composite-page" id="p6">
            <h2 data-type="document-title">
              <span class="os-text">Chapter 1</span>
            </h2>
          </div>
        </div>
        <div class="os-index-container" data-type="composite-page" id="p7">
          <h1 data-type="document-title">
            <span class="os-text">Index</span>
          </h1>
        </div>
      HTML
    ).tap do |book|
      # TOC runs after introduction baking which changes some selectors
      Kitchen::Directions::BakeChapterIntroductions.v1_update_selectors(book)
    end
  end

  let(:preface_page) do
    page_element(
      <<~HTML
        <div data-type="page" id="p1" class="preface">
          <h1 data-type="document-title">
            <span data-type="" itemprop="" class="os-text">Preface</span>
          </h1>
        </div>
      HTML
    )
  end

  let(:page1) do
    new_element(
      <<~HTML
        <div data-type="composite-page">
          <h1 data-type="document-title">
            <span class="os-text">Index</span>
          </h1>
        </div>
      HTML
    )
  end

  it 'works with unit' do
    described_class.v1(book: book_unit)

    expect(book_unit.search('nav').to_s).to match_normalized_html(
      <<~HTML
        <nav id="toc">
          <h1 class="os-toc-title">Contents</h1>
          <ol>
            <li class="os-toc-preface" cnx-archive-shortid="" cnx-archive-uri="p1">
              <a href="#p1">
                <span class="os-text" data-type="" itemprop="">Preface</span>
              </a>
            </li>
            <li class="os-toc-unit" cnx-archive-shortid="" cnx-archive-uri="">
              <a href="#">
                <span class="os-number"><span class="os-part-text">Unit </span> 1</span>
                <span class="os-divider"> </span>
                <span class="os-text" data-type="" itemprop=""> Unit 1 Title </span>
              </a>
              <ol class="os-unit">
                <li class="os-toc-chapter" cnx-archive-shortid="" cnx-archive-uri="">
                  <a href="#chapTitle1">
                    <span class="os-number"><span class="os-part-text">Chapter </span>1</span>
                    <span class="os-divider"> </span>
                    <span class="os-text" data-type="" itemprop="">Chapter 1 Title</span>
                  </a>
                  <ol class="os-chapter">
                    <li class="os-toc-chapter-page" cnx-archive-shortid="" cnx-archive-uri="p2">
                      <a href="#p2">
                        <span class="os-text" data-type="" itemprop="">Introduction</span>
                      </a>
                    </li>
                    <li class="os-toc-chapter-page" cnx-archive-shortid="" cnx-archive-uri="p3">
                      <a href="#p3">
                        <span class="os-number">1.1</span>
                        <span class="os-divider"> </span>
                        <span class="os-text" data-type="" itemprop="">Page 1.1 Title</span>
                      </a>
                    </li>
                    <li class="os-toc-chapter-composite-page" cnx-archive-shortid="" cnx-archive-uri="composite-page-1">
                      <a href="#composite-page-1">
                        <span class="os-text">Key Terms</span>
                      </a>
                    </li>
                  </ol>
                </li>
                <li class="os-toc-chapter" cnx-archive-shortid="" cnx-archive-uri="">
                  <a href="#chapTitle2">
                    <span class="os-number"><span class="os-part-text">Chapter </span>2</span>
                    <span class="os-divider"> </span>
                    <span class="os-text" data-type="" itemprop="">Chapter 2 Title</span>
                  </a>
                  <ol class="os-chapter">
                    <li class="os-toc-chapter-page" cnx-archive-shortid="" cnx-archive-uri="p4">
                      <a href="#p4">
                        <span class="os-number">2.1</span>
                        <span class="os-divider"> </span>
                        <span class="os-text" data-type="" itemprop="">Page 2.1 Title</span>
                      </a>
                    </li>
                  </ol>
                </li>
              </ol>
            </li>
            <li class="os-toc-unit" cnx-archive-shortid="" cnx-archive-uri="">
              <a href="#">
                <span class="os-number"><span class="os-part-text">Unit </span> 2</span>
                <span class="os-divider"> </span>
                <span class="os-text" data-type="" itemprop=""> Unit 2 Title </span>
              </a>
              <ol class="os-unit">
                <li class="os-toc-chapter" cnx-archive-shortid="" cnx-archive-uri="">
                  <a href="#chapTitle3">
                    <span class="os-number"><span class="os-part-text">Chapter </span>3</span>
                    <span class="os-divider"> </span>
                    <span class="os-text" data-type="" itemprop="">Chapter 3 Title</span>
                  </a>
                  <ol class="os-chapter">
                    <li class="os-toc-chapter-page" cnx-archive-shortid="" cnx-archive-uri="p5">
                      <a href="#p5">
                        <span class="os-text" data-type="" itemprop="">Introduction</span>
                      </a>
                    </li>
                    <li class="os-toc-chapter-page" cnx-archive-shortid="" cnx-archive-uri="p6">
                      <a href="#p6">
                        <span class="os-number">3.1</span>
                        <span class="os-divider"> </span>
                        <span class="os-text" data-type="" itemprop="">Page 3.1 Title</span>
                      </a>
                    </li>
                    <li class="os-toc-chapter-composite-page" cnx-archive-shortid="" cnx-archive-uri="composite-page-2">
                      <a href="#composite-page-2">
                        <span class="os-text">Key Terms</span>
                      </a>
                    </li>
                  </ol>
                </li>
              </ol>
            </li>
            <li class="os-toc-appendix" cnx-archive-shortid="" cnx-archive-uri="p7">
              <a href="#p7">
                <span class="os-number"><span class="os-part-text">Appendix </span>A</span>
                <span class="os-divider"> </span>
                <span class="os-text" data-type="" itemprop="">Appendix A Title</span>
              </a>
            </li>
            <li class="os-toc-composite-chapter" cnx-archive-shortid="" cnx-archive-uri="">
              <a href="#composite-chapter-1">
                <span class="os-text">Answer Key</span>
              </a>
              <ol class="os-chapter">
                <li class="os-toc-chapter-composite-page" cnx-archive-shortid="" cnx-archive-uri="p8">
                  <a href="#p8">
                    <span class="os-text">Chapter 1</span>
                  </a>
                </li>
              </ol>
            </li>
            <li class="os-toc-index" cnx-archive-shortid="" cnx-archive-uri="p9">
              <a href="#p9">
                <span class="os-text">Index</span>
              </a>
            </li>
          </ol>
        </nav>
      HTML
    )
  end

  it 'works without unit' do
    described_class.v1(book: book_no_unit)

    expect(book_no_unit.search('nav').to_s).to match_normalized_html(
      <<~HTML
        <nav id="toc">
          <h1 class="os-toc-title">Contents</h1>
          <ol>
            <li class="os-toc-preface" cnx-archive-shortid="" cnx-archive-uri="p1">
              <a href="#p1">
                <span class="os-text" data-type="" itemprop="">Preface</span>
              </a>
            </li>
            <li class="os-toc-chapter" cnx-archive-shortid="" cnx-archive-uri="">
              <a href="#chapTitle1">
                <span class="os-number"><span class="os-part-text">Chapter </span>1</span>
                <span class="os-divider"> </span>
                <span class="os-text" data-type="" itemprop="">Chapter 1 Title</span>
              </a>
              <ol class="os-chapter">
                <li class="os-toc-chapter-page" cnx-archive-shortid="" cnx-archive-uri="p2">
                  <a href="#p2">
                    <span class="os-text" data-type="" itemprop="">Introduction</span>
                  </a>
                </li>
                <li class="os-toc-chapter-page" cnx-archive-shortid="" cnx-archive-uri="p3">
                  <a href="#p3">
                    <span class="os-number">1.1</span>
                    <span class="os-divider"> </span>
                    <span class="os-text" data-type="" itemprop="">Page 1.1 Title</span>
                  </a>
                </li>
                <li class="os-toc-chapter-composite-page" cnx-archive-shortid="" cnx-archive-uri="composite-page-1">
                  <a href="#composite-page-1">
                    <span class="os-text">Key Terms</span>
                  </a>
                </li>
              </ol>
            </li>
            <li class="os-toc-chapter" cnx-archive-shortid="" cnx-archive-uri="">
              <a href="#chapTitle2">
                <span class="os-number"><span class="os-part-text">Chapter </span>2</span>
                <span class="os-divider"> </span>
                <span class="os-text" data-type="" itemprop="">Chapter 2 Title</span>
              </a>
              <ol class="os-chapter">
                <li class="os-toc-chapter-page" cnx-archive-shortid="" cnx-archive-uri="p4">
                  <a href="#p4">
                    <span class="os-number">2.1</span>
                    <span class="os-divider"> </span>
                    <span class="os-text" data-type="" itemprop="">Page 2.1 Title</span>
                  </a>
                </li>
              </ol>
            </li>
            <li class="os-toc-appendix" cnx-archive-shortid="" cnx-archive-uri="p5">
              <a href="#p5">
                <span class="os-number"><span class="os-part-text">Appendix </span>A</span>
                <span class="os-divider"> </span>
                <span class="os-text" data-type="" itemprop="">Appendix A Title</span>
              </a>
            </li>
            <li class="os-toc-composite-chapter" cnx-archive-shortid="" cnx-archive-uri="">
              <a href="#composite-chapter-1">
                <span class="os-text">Answer Key</span>
              </a>
              <ol class="os-chapter">
                <li class="os-toc-chapter-composite-page" cnx-archive-shortid="" cnx-archive-uri="p6">
                  <a href="#p6">
                    <span class="os-text">Chapter 1</span>
                  </a>
                </li>
              </ol>
            </li>
            <li class="os-toc-index" cnx-archive-shortid="" cnx-archive-uri="p7">
              <a href="#p7">
                <span class="os-text">Index</span>
              </a>
            </li>
          </ol>
        </nav>
      HTML
    )
  end

  describe 'raises error' do
    it 'Page element classes not found' do
      expect do
        described_class.li_for_page(preface_page)
      end.to raise_error("do not know what TOC class to use for page with classes #{preface_page.classes}")
    end

    it 'Composite page element classes not found' do
      dummy_document = Kitchen::Document.new(nokogiri_document: nil)
      composite_page = Kitchen::CompositePageElement.new(node: page1, document: dummy_document)
      expect do
        described_class.li_for_page(composite_page)
      end.to raise_error("do not know what TOC class to use for page with classes #{composite_page.classes}")
    end

    it 'No familiar classes found' do
      expect do
        described_class.li_for_page(page1)
      end.to raise_error("don't know how to put `#{page1.class}` into the TOC")
    end
  end
end
