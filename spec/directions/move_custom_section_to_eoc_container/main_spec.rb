# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::MoveCustomSectionToEocContainer do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::MoveCustomSectionToEocContainer::V1).to receive(:bake)
      .with(chapter: 'chapter1', metadata_source: 'metadata', title_key: 'some-class', uuid_key: 'other-class', container_class_type: 'another-class', section_selector: 'yet-another-class',
            append_to: 'element', include_intro_page: true)
    described_class.v1(chapter: 'chapter1', metadata_source: 'metadata', title_key: 'some-class', uuid_key: 'other-class', container_class_type: 'another-class',
                       section_selector: 'yet-another-class', append_to: 'element')
  end
end
