require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterSummary do

  let(:chapter) do
    chapter_element(
      <<~HTML
        <section class="key-equations">
          <h3>WWF History</h3>
          <p>Equations blah.</p>
        </section>
      HTML
    )
  end

  #TODO: check that it:
  #Replaces title with h3 title (children: os-number, os-divider, os-text)
  #

  context 'when v1 is called on a book' do
    it 'works' do
      expect(
        described_class.v1(chapter: chapter, metadata_source: metadata_element)
      ).to match_normalized_html(
        <<~HTML
          <div> </div>
        HTML
      )
    end
  end
end
