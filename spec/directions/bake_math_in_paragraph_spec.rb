require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeMathInParagraph do
  let(:book) do
    book_containing(html:
      <<~HTML
        <div>
          <p>
            <math>
              <msup>
                <mn>10</mn>
                <mn>3</mn>
              </msup>
            </math>
          </p>
        </div>
      HTML
    )
  end

  it 'works' do
    #this works
    puts book.search('p math').count
    #this doesnt
    puts described_class.v1(book: book)
    puts book.body

    #expect(
    #  described_class.v1(chapter: chapter, metadata_source: metadata_element)
    #).to match_normalized_html(
    #  <<~HTML
    #  HTML
    #)
  end
end
