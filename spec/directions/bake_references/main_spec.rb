# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeReferences do
  let(:book1) do
    book_containing(html:
    <<~HTML
      <div data-type="chapter">
        <h1 data-type="document-title" id="chapTitle1">
          <span class="os-part-text">Chapter </span>
          <span class="os-number">1</span>
          <span class="os-divider"> </span>
          <span class="os-text" data-type="" itemprop="">Title Text Chapter 1</span>
        </h1>
        <div data-type="page">
          #{metadata_element}
          <p>
            <a href="#auto_12345" data-type="cite">
              <div data-type="note" class="reference" display="inline" id="auto_12345">
                Reference 1
              </div>
            </a>
            <a href="#auto_54321" data-type="cite">
              <div data-type="note" class="reference" display="inline" id="auto_54321">
                Reference 2
              </div>
            </a>
          </p>
        </div>
      </div>
      <div data-type="chapter">
        <h1 data-type="document-title" id="chapTitle2">
          <span class="os-part-text">Chapter </span>
          <span class="os-number">2</span>
          <span class="os-divider"> </span>
          <span class="os-text" data-type="" itemprop="">Title Text Chapter 2</span>
        </h1>
        <div data-type="page">
          #{metadata_element}
          <p>
            <a href="#auto_6789" data-type="cite">
              <div data-type="note" class="reference" display="inline" id="auto_6789">
                Reference 3
              </div>
            </a>
          </p>
        </div>
      </div>
    HTML
    )
  end

  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeReferences::V1).to receive(:bake)
      .with(book: book1)
    described_class.v1(book: book1, metadata_source: metadata_element)
  end

  it 'calls v2' do
    expect_any_instance_of(Kitchen::Directions::BakeReferences::V2).to receive(:bake)
      .with(book: book1)
    described_class.v2(book: book1, metadata_source: metadata_element)
  end

  it 'calls v3' do
    expect_any_instance_of(Kitchen::Directions::BakeReferences::V3).to receive(:bake)
      .with(book: book1)
    described_class.v3(book: book1, metadata_source: metadata_element)
  end
end
