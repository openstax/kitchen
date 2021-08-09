# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeIndex::V1 do

  let(:a_section) { described_class::IndexSection.new(name: 'whatever') }

  it 'sorts terms with accent marks' do
    a_section.add_term(text_only_term('Hu'))
    a_section.add_term(text_only_term('Hückel'))
    a_section.add_term(text_only_term('Héroult'))
    a_section.add_term(text_only_term('Hunk'))

    expect(a_section.items.map(&:term_text)).to eq %w[Héroult Hu Hückel Hunk]
  end

  it 'sorts terms starting with symbols' do
    a_section.add_term(text_only_term('Δoct'))
    a_section.add_term(text_only_term('π*'))
    expect(a_section.items.map(&:term_text)).to eq %w[Δoct π*]
  end

  it 'sorts index items with superscript' do
    a_section.add_term(text_only_term('sp hybrid'))
    a_section.add_term(text_only_term('sp2 hybrid'))    # sp^2 hybrid
    a_section.add_term(text_only_term('sp3 hybrid'))    # sp^3 hybrid
    a_section.add_term(text_only_term('sp3d hybrid'))   # (sp^3)(d) hybrid
    a_section.add_term(text_only_term('sp3d2 hybrid'))  # (sp^3)(d^2) hybrid
    expect(a_section.items.map(&:term_text)).to eq [
      'sp hybrid', 'sp2 hybrid', 'sp3 hybrid', 'sp3d hybrid', 'sp3d2 hybrid'
    ]
  end

  it 'collapses the same term with different capitalization into one item with lowercase' do
    a_section.add_term(text_only_term('temperature'))
    a_section.add_term(text_only_term('Temperature'))
    expect(a_section.items.count).to eq 1
    expect(a_section.items.first.term_text).to eq 'temperature'
  end

  def text_only_term(text)
    described_class::Term.new(text: text, id: nil, group_by: nil, page_title: nil)
  end

end
