require 'spec_helper'

RSpec.describe Kitchen::PageElement do

  let(:page_title_text) { 'A title!' }

  let(:metadata) do
    <<~HTML
      <div data-type="metadata" style="display: none;">
        <h1 data-type="document-title" itemprop="name">#{page_title_text}</h1>
      </div>
    HTML
  end

  let(:page1) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          #{metadata}
          <div data-type="document-title">#{page_title_text}</div>
        HTML
      )).pages.first
  end

  let(:page2) do
    book_containing(html:
      <<~HTML
        <div data-type="page">
          <div data-type="document-title">Title</div>
          <div data-type="metadata">
            <div data-type="document-title">Title MetaData</div>
          </div>
        </div>
      HTML
    )
  end

  describe '#title' do
    context 'with no metadata' do
      let(:metadata) { '' }

      it 'finds the title' do
        expect(page1.title.text).to eq page_title_text
      end
    end

    context 'with metadata' do
      it 'finds the title' do
        expect(page1.title.text).to eq page_title_text
      end
    end
  end

  describe '#titles' do
    it 'returns all titles in element' do
      page_titles = '<div data-type="document-title">Title</div>'\
      '<div data-type="document-title">Title MetaData</div>'
      expect(page2.pages[0].titles.to_s).to eq page_titles
    end
  end

end
