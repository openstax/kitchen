# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeGenericEocSection do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeGenericEocSection::V1).to receive(:bake)
      .with(chapter: 'chapter1', metadata_source: 'metadata', append_to: 'element', klass: 'class', uuid_prefix: 'uuid', include_intro: true)
    described_class.v1(chapter: 'chapter1', metadata_source: 'metadata', append_to: 'element', klass: 'class', uuid_prefix: 'uuid')
  end
end
