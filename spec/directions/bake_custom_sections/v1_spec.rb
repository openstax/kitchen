require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeCustomSections::V1 do

  before do
    stub_locales({
      'custom_sections': {
        'narrative_trailblazer': 'Literacy Narrative Trailblazer',
        'living_words': 'Living by Their Own Words',
        'quick_launch': 'Quick Launch:',
        'drafting': 'Drafting:',
        'peer-review': 'Peer Review:'
        }
      })
  end

  let(:chapter) do
    chapter_element(
      <<~HTML
        <div class="chapter-content-module narrative-trailblazer" data-type="page">
          <h2 data-type="document-title">
            <span class="os-number">1.2</span>
            <span class="os-divider"> </span>
            <span class="os-text" data-type="" itemprop="">Tara Westover (b. 1986)</span>
          </h2>
          <div><!-- no-selfclose --></div>
          <section class="peer-review" data-depth="1">
            <h3 data-type="title">Giving Specific Praise and Constructive Feedback</h3>
          </section>
          <section class="quick-launch" data-depth="1">
              <h3 data-type="title">Defining Your Rhetorical Situation, Generating Ideas, and Organizing</h3>
          </section>
          <section class="living-words" data-depth="1">
            <h3 data-type="title">Literacy from Unexpected Sources</h3>
          <section>
          <section class="drafting" data-depth="1">
          <h3 data-type="title">Writing from Personal Experience and Observation</h3>
          </section>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(chapter: chapter)
    expect(chapter).to match_normalized_html(
      <<~HTML
        <div data-type="chapter">
          <div class="chapter-content-module narrative-trailblazer" data-type="page">
            <h2 data-type="document-title">
              <span class="os-number">1.2</span>
              <span class="os-divider"> </span>
              <span class="os-text" data-type="" itemprop="">Literacy Narrative Trailblazer</span>
            </h2>
            <h3 class="os-subtitle">Tara Westover (b. 1986)</h3>
            <section class="peer-review" data-depth="1">
              <h3 data-type="title">Peer Review: Giving Specific Praise and Constructive Feedback</h3>
            </section>
            <section class="quick-launch" data-depth="1">
              <h3 data-type="title">Quick Launch: Defining Your Rhetorical Situation, Generating Ideas, and Organizing</h3>
            </section>
            <section class="living-words" data-depth="1">
              <h3 data-type="title">Living by Their Own Words</h3>
              <h4 data-type="title">Literacy from Unexpected Sources</h4>
            </section>
            <section class="drafting" data-depth="1">
              <h3 data-type="title">Drafting: Writing from Personal Experience and Observation</h3>
            </section>
          </div>
        </div>
      HTML
    )
  end
end
