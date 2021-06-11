# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BookAnswerKeyContainer::V1 do
  let(:book) do
    book_containing(html:
      <<~HTML
        #{metadata_element}
        <div data-type="chapter">
          <div data-type="page">
            This is a page
          </div>
        </div>
      HTML
    )
  end

<<<<<<< HEAD
  context 'when klass value is set to default' do
    it 'works' do
      expect(described_class.new.bake(book: book, klass: 'solutions')).to match_normalized_html(
        <<~HTML
          <div class="os-eob os-solutions-container" data-type="composite-chapter" data-uuid-key=".solutions">
            <h1 data-type="document-title">
              <span class="os-text">Answer Key</span>
            </h1>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Answer Key</h1>
              <div class="authors">
              <span id="author-1_copy_1"><a>OpenStaxCollege</a></span>
            </div><div class="publishers">
              <span id="publisher-1_copy_1"><a>OpenStaxCollege</a></span>
            </div><div class="print-style">
              <span data-type="print-style">ccap-calculus</span>
            </div><div class="permissions">
              <p class="copyright">
                <span id="copyright-holder-1_copy_1"><a>OSCRiceUniversity</a></span>
              </p>
              <p class="license">
                <a>CC BY</a>
              </p>
            </div><div itemprop="about" data-type="subject">Math</div>
            </div>
=======
  it 'works' do
    expect(described_class.new.bake(book: book)).to match_normalized_html(
      <<~HTML
        <div class="os-eob os-solutions-container" data-type="composite-chapter" data-uuid-key=".solutions">
          <h1 data-type="document-title">
            <span class="os-text">Answer Key</span>
          </h1>
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">Answer Key</h1>
            <div class="authors" id="authors_copy_1">Authors</div>
            <div class="publishers" id="publishers_copy_1">Publishers</div>
            <div class="print-style" id="print-style_copy_1">Print Style</div>
            <div class="permissions" id="permissions_copy_1">Permissions</div>
            <div data-type="subject" id="subject_copy_1">Subject</div>
>>>>>>> main
          </div>
        HTML
      )
    end
  end

  context 'when klass value is set to "solution"' do
    it 'works' do
      expect(described_class.new.bake(book: book, klass: 'solution')).to match_normalized_html(
        <<~HTML
          <div class="os-eob os-solution-container" data-type="composite-chapter" data-uuid-key=".solution">
            <h1 data-type="document-title">
              <span class="os-text">Answer Key</span>
            </h1>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Answer Key</h1>
              <div class="authors">
              <span id="author-1_copy_1"><a>OpenStaxCollege</a></span>
            </div><div class="publishers">
              <span id="publisher-1_copy_1"><a>OpenStaxCollege</a></span>
            </div><div class="print-style">
              <span data-type="print-style">ccap-calculus</span>
            </div><div class="permissions">
              <p class="copyright">
                <span id="copyright-holder-1_copy_1"><a>OSCRiceUniversity</a></span>
              </p>
              <p class="license">
                <a>CC BY</a>
              </p>
            </div><div itemprop="about" data-type="subject">Math</div>
            </div>
          </div>
        HTML
      )
    end
  end

  it 'generates container with solution (singular) class' do
    expect(described_class.new.bake(book: book, solutions_plural: false)).to match_normalized_html(
      <<~HTML
        <div class="os-eob os-solution-container" data-type="composite-chapter" data-uuid-key=".solution">
          <h1 data-type="document-title">
            <span class="os-text">Answer Key</span>
          </h1>
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">Answer Key</h1>
            <div class="authors" id="authors_copy_1">Authors</div>
            <div class="publishers" id="publishers_copy_1">Publishers</div>
            <div class="print-style" id="print-style_copy_1">Print Style</div>
            <div class="permissions" id="permissions_copy_1">Permissions</div>
            <div data-type="subject" id="subject_copy_1">Subject</div>
          </div>
        </div>
      HTML
    )
  end
end
