# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeLOLinkLabel do

  let(:book_with_lo_reference_links) do
    book_containing(html:
      <<~HTML
        <a>skip this link</a>
        <a href='?key'>Example x.y</a>
        <a class='lo-reference autogenerated-content' href='?other_key'>x.y</a>
      HTML
    )
  end

  before do
    # book_with_lo_reference_links.pantry(name: :link_text).store('Example x.y', label: 'key')
    # book_with_lo_reference_links.pantry(name: :link_text).store('x.y', label: 'other_key')
    stub_locales({
      'lo_label_text': 'LO '
    })
  end

    it 'bakes' do
      described_class.v1(book: book_with_lo_reference_links)
      expect(book_with_lo_reference_links.body).to match_normalized_html(
        <<~HTML
          <body>
            <a>skip this link</a>
            <a href='?key'>Example x.y</a>
            <a class='lo-reference autogenerated-content' href='?other_key'>
              <span class="label-text">LO </span>
              <span class="label-counter">x.y</span>
            </a>
          </body>
        HTML
      )
    end
end

