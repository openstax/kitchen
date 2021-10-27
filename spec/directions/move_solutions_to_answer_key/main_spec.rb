# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::MoveSolutionsToAnswerKey do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::AnswerKeyInnerContainer::V1).to receive(:bake).with(
      chapter: 'chapter1',
      metadata_source: 'metadata',
      append_to: 'element',
      solutions_plural: true
    )
    described_class.v1(chapter: 'chapter1', metadata_source: 'metadata', append_to: 'element')
  end
end
