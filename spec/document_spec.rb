# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Document do
  let(:xml) do
    Nokogiri::XML(
      <<~HTML
        <html>
          <body>
            <div class='hi'>Howdy</div>
          </body>
        </html>
      HTML
    )
  end

  let(:dummy_document) { described_class.new(nokogiri_document: xml) }

  it 'counter works' do
    expect(dummy_document.counter(:chapter).get).to eq(0)
  end

  it 'creates element' do
    expect(dummy_document.create_element('div', class: 'foo')).to match_normalized_html(
      <<~HTML
        <div class="foo"/>
      HTML
    )
  end

  it 'creates element from string' do
    expect(
      dummy_document.create_element_from_string("<div class='foo'>bar</div>")
    ).to match_normalized_html(
      <<~HTML
        <div class="foo">bar</div>
      HTML
    )
  end
end
