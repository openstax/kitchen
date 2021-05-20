# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::MoveSolutionsToAnswerKey do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::MoveSolutionsToAnswerKey::V1).to receive(:bake)
      .with(chapter: 'chapter1', metadata_source: 'metadata', strategy: 'strategy', append_to: 'element', klass: 'solutions')
    described_class.v1(chapter: 'chapter1', metadata_source: 'metadata', strategy: 'strategy', append_to: 'element', klass: 'solutions')
  end
end
