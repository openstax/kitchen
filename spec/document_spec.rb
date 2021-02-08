# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Document do
  let(:book1) do
    new_element(
      <<~HTML
        <div>
          <div data-type="chapter" id="chapter1">
            <span>This is a chapter</span>
          </div>
        </div>
      HTML
    )
  end

  it 'counter works' do
    expect(book1.document.counter(:chapter).get).to eq(0)
  end

  it 'creates element' do
    expect(book1.document.create_element('div', class: 'foo')).to match_normalized_html(
      <<~HTML
        <div class="foo"/>
      HTML
    )
  end

  it 'creates element from string' do
    expect(
      book1.document.create_element_from_string("<div class='foo'>bar</div>")
    ).to match_normalized_html(
      <<~HTML
        <div class="foo">bar</div>
      HTML
    )
  end
end
