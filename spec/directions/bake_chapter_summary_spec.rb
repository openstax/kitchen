require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterSummary do
  let(:book) do
    book_containing(html:
      <<~HTML
        <div> </div>
      HTML
    )
  end

  #TODO: check that it:
  #Replaces title with h3 title (children: os-number, os-divider, os-text)
  #

  context 'when v1 is called on a book' do
    it 'works' do
      described_class.v1(book: book)
      byebug
      expect(book).to match_normalized_html(
        <<~HTML
          <div> </div>
        HTML
      )
    end
  end
end
