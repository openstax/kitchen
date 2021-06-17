# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::EocContentTransform do
  let(:section_with_h3) do
    book_containing(html:
      <<~HTML
        <section class="whatever">
          <h3 data-type="title">A spare title</h3>
          <div>content</div>
        </section>
      HTML
    ).search('section').first
  end

  describe '#v1' do
    it 'sends to a method' do
      expect(described_class).to receive(:foo)
      described_class.v1(section: '', strategy: :foo)
    end
  end

  describe '#remove_title' do
    it 'removes the stray title from a section' do
      described_class.v1(section: section_with_h3, strategy: :remove_title)
      expect(section_with_h3).to match_normalized_html(
        <<~HTML
          <section class="whatever">
            <div>content</div>
          </section>
        HTML
      )
    end
  end
end
