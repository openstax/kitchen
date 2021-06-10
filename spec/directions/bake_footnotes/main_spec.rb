# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeFootnotes do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeFootnotes::V1).to receive(:bake).with(book: 'blah')
    described_class.v1(book: 'blah')
  end

  it 'calls v2' do
    expect_any_instance_of(Kitchen::Directions::BakeFootnotes::V2).to receive(:bake).with(book: 'blah')
    described_class.v2(book: 'blah')
  end

  it 'as_roman works' do
    expect(described_class.as_roman(3)).to eq('iii')
    expect(described_class.as_roman(10)).to eq('x')
    expect {
      described_class.as_roman(11)
    }.to raise_error('Unknown conversion to Roman numerals')
  end
end
