# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterKeyEquations do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeChapterKeyEquations::V1).to receive(:bake)
      .with(chapter: 'chapter1', metadata_source: 'metadata', append_to: 'chapter')
    described_class.v1(chapter: 'chapter1', metadata_source: 'metadata', append_to: 'chapter')
  end
end
