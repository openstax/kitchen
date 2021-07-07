# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::EocCompositePageContainer do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::EocCompositePageContainer::V1).to receive(:bake)
      .with(title_key: 'some-section', uuid_key: 'some-section', container_class_type: 'some-section', metadata_source: 'metadata', content: 'content', append_to: nil)
    described_class.v1(title_key: 'some-section', uuid_key: 'some-section', container_class_type: 'some-section', metadata_source: 'metadata', content: 'content')
  end
end
